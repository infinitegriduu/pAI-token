// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

//@title pAI Token - Mineable AI-themed ERC20 Token using Proof Of Work + Linear Vesting
//@notice Symbol: pAI | Name: Proof of AI | Decimals: 18
//@dev Total supply: 150,000,000 pAI (66.67% initial allocation, 33.33% POW mined)

// ============================================================================
// Custom Errors (Gas Optimized)
// ============================================================================
error InvalidProofOfWork();
error AlreadyMinedInBlock();
error MaxSupplyExceeded();
error PermitExpired();
error InvalidSignature();
error ETHNotAccepted();
error ZeroAddress();
error InsufficientBalance();
error InsufficientAllowance();
error TooSoonToClaim();
error InsufficientHashPower();
error VestingPoolDepleted();

// ============================================================================
// Interfaces
// ============================================================================

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

interface IERC20Permit {
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function nonces(address owner) external view returns (uint256);
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

// ============================================================================
// Libraries
// ============================================================================

library ExtendedMath {
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    function limitLessThan(
        uint256 a,
        uint256 b
    ) internal pure returns (uint256) {
        return a > b ? b : a;
    }
}

library ECRecover {
    function recover(
        bytes32 digest,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal pure returns (address) {
        if (
            uint256(s) >
            0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
        ) {
            revert InvalidSignature();
        }
        if (v != 27 && v != 28) {
            revert InvalidSignature();
        }

        address signer = ecrecover(digest, v, r, s);
        if (signer == address(0)) {
            revert InvalidSignature();
        }

        return signer;
    }
}

library EIP712 {
    function makeDomainSeparator(
        string memory name,
        string memory version,
        address verifyingContract
    ) internal view returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    keccak256(
                        "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                    ),
                    keccak256(bytes(name)),
                    keccak256(bytes(version)),
                    block.chainid,
                    verifyingContract
                )
            );
    }

    function recover(
        bytes32 domainSeparator,
        uint8 v,
        bytes32 r,
        bytes32 s,
        bytes memory typeHashAndData
    ) internal pure returns (address) {
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                domainSeparator,
                keccak256(typeHashAndData)
            )
        );
        return ECRecover.recover(digest, v, r, s);
    }
}

// ============================================================================
// Main Contract
// ============================================================================

contract pAIToken is IERC20, IERC20Metadata, IERC20Permit {
    using ExtendedMath for uint256;

    // ========================================================================
    // State Variables
    // ========================================================================

    // ERC20 Basic
    string public constant name = "Proof of AI";
    string public constant symbol = "pAI";
    uint8 public constant decimals = 18;
    string public constant version = "1";

    uint256 public totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // EIP-2612 Permit
    bytes32 public immutable DOMAIN_SEPARATOR;
    bytes32 public constant PERMIT_TYPEHASH =
        keccak256(
            "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
        );
    mapping(address => uint256) private _nonces;

    // ========================================================================
    // Supply Distribution Constants
    // ========================================================================

    uint256 public constant MAXIMUM_SUPPLY = 150_000_000 * 10 ** 18; // 150M pAI
    uint256 public constant INITIAL_ALLOCATION = 100_000_000 * 10 ** 18; // 100M pAI (66.67%)
    uint256 public constant MINEABLE_SUPPLY = 50_000_000 * 10 ** 18; // 50M pAI (33.33%)

    /// @notice Traditional PoW allocation (instant rewards)
    uint256 public constant POW_ALLOCATION = 40_000_000 * 10 ** 18; // 40M pAI (80% of mineable)

    /// @notice Linear vesting pool allocation
    uint256 public constant VESTING_POOL_ALLOCATION = 10_000_000 * 10 ** 18; // 10M pAI (20% of mineable)

    // Total mineable: 40M + 10M = 50M ✅

    // ========================================================================
    // POW Mining State
    // ========================================================================

    uint256 public constant BLOCKS_PER_READJUSTMENT = 2048;
    uint256 public constant MINIMUM_TARGET = 2 ** 16;
    uint256 public constant MAXIMUM_TARGET = 2 ** 234;
    uint256 public constant TARGET_BLOCKS_PER_PERIOD =
        BLOCKS_PER_READJUSTMENT * 40;

    uint256 public miningTarget;
    bytes32 public challengeNumber;
    uint256 public epochCount;
    uint256 public rewardEra;
    uint256 public maxSupplyForEra;
    uint256 public currentMiningReward;
    uint256 public tokensMinted;
    uint256 public latestDifficultyPeriodStarted;
    uint256 public lastRewardEthBlockNumber;

    address public lastRewardTo;
    uint256 public lastRewardAmount;

    address public immutable initialRecipient;

    // ========================================================================
    // Linear Vesting Mining System
    // ========================================================================

    uint256 public constant DAILY_VESTING_REWARD = 0.5 * 10 ** 18;
    uint256 public constant REQUIRED_DAILY_HASH_POWER = 10;

    uint256 public totalVestingClaimed;
    uint256 public totalActiveMiners;

    struct MinerStake {
        uint256 lastClaimTime;
        uint256 accumulatedHashPower;
        uint256 totalVestingClaimed;
        uint256 totalHashPowerSubmitted;
        uint256 firstSubmissionTime;
    }

    mapping(address => MinerStake) public minerStakes;

    // ========================================================================
    // Events
    // ========================================================================

    event Mint(
        address indexed miner,
        uint256 reward,
        uint256 epochCount,
        bytes32 newChallengeNumber
    );
    event DifficultyAdjusted(
        uint256 oldTarget,
        uint256 newTarget,
        uint256 ethBlocksSinceLastAdjustment
    );
    event EraTransition(uint256 newEra, uint256 newReward);
    event InitialAllocation(address indexed recipient, uint256 amount);
    event HashPowerSubmitted(
        address indexed miner,
        uint256 hashPower,
        uint256 totalHashPower
    );
    event VestingRewardClaimed(
        address indexed miner,
        uint256 amount,
        uint256 daysClaimed,
        uint256 hashPowerUsed
    );

    // ========================================================================
    // Constructor
    // ========================================================================

    constructor(address _initialRecipient) {
        if (_initialRecipient == address(0)) revert ZeroAddress();

        initialRecipient = _initialRecipient;

        DOMAIN_SEPARATOR = EIP712.makeDomainSeparator(
            name,
            version,
            address(this)
        );

        _mint(_initialRecipient, INITIAL_ALLOCATION);
        emit InitialAllocation(_initialRecipient, INITIAL_ALLOCATION);

        miningTarget = MAXIMUM_TARGET;
        challengeNumber = blockhash(block.number - 1);
        rewardEra = 0;
        currentMiningReward = 100 * 10 ** decimals;
        maxSupplyForEra = INITIAL_ALLOCATION + (POW_ALLOCATION / 2); // 100M + 20M = 120M
        latestDifficultyPeriodStarted = block.number;
        epochCount = 0;
        tokensMinted = 0;
    }

    // ========================================================================
    // ERC20 Standard Functions
    // ========================================================================

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(
        address to,
        uint256 amount
    ) public override returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(
        address spender,
        uint256 amount
    ) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        uint256 currentAllowance = _allowances[from][msg.sender];
        if (currentAllowance < amount) revert InsufficientAllowance();

        unchecked {
            _approve(from, msg.sender, currentAllowance - amount);
        }
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        if (from == address(0)) revert ZeroAddress();
        if (to == address(0)) revert ZeroAddress();
        if (_balances[from] < amount) revert InsufficientBalance();

        unchecked {
            _balances[from] -= amount;
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        if (owner == address(0)) revert ZeroAddress();
        if (spender == address(0)) revert ZeroAddress();

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _mint(address account, uint256 amount) internal {
        if (account == address(0)) revert ZeroAddress();

        unchecked {
            totalSupply += amount;
            _balances[account] += amount;
        }

        emit Transfer(address(0), account, amount);
    }

    // ========================================================================
    // EIP-2612 Permit Functions
    // ========================================================================

    function nonces(address owner) public view override returns (uint256) {
        return _nonces[owner];
    }

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external override {
        if (block.timestamp > deadline) revert PermitExpired();

        bytes memory data = abi.encode(
            PERMIT_TYPEHASH,
            owner,
            spender,
            value,
            _nonces[owner]++,
            deadline
        );

        address recoveredAddress = EIP712.recover(
            DOMAIN_SEPARATOR,
            v,
            r,
            s,
            data
        );
        if (recoveredAddress != owner) revert InvalidSignature();

        _approve(owner, spender, value);
    }

    // ========================================================================
    // POW Mining Functions (Traditional)
    // ========================================================================

    function mint(uint256 nonce) external returns (bool success) {
        return _mintTo(nonce, msg.sender);
    }

    function mintTo(
        uint256 nonce,
        address minter
    ) external returns (bool success) {
        return _mintTo(nonce, minter);
    }

    function _mintTo(uint256 nonce, address minter) internal returns (bool) {
        if (minter == address(0)) revert ZeroAddress();

        bytes32 digest = keccak256(
            abi.encodePacked(
                keccak256(abi.encodePacked(challengeNumber, minter, nonce))
            )
        );

        if (uint256(digest) > miningTarget) revert InvalidProofOfWork();
        if (lastRewardEthBlockNumber == block.number)
            revert AlreadyMinedInBlock();
        if (tokensMinted + currentMiningReward > maxSupplyForEra)
            revert MaxSupplyExceeded();

        _mint(minter, currentMiningReward);

        unchecked {
            tokensMinted += currentMiningReward;
        }

        lastRewardTo = minter;
        lastRewardAmount = currentMiningReward;
        lastRewardEthBlockNumber = block.number;

        _startNewMiningEpoch();

        emit Mint(minter, currentMiningReward, epochCount, challengeNumber);

        return true;
    }

    function _startNewMiningEpoch() internal {
        if (
            totalSupply + currentMiningReward > maxSupplyForEra && rewardEra < 7
        ) {
            unchecked {
                rewardEra++;
            }

            currentMiningReward = currentMiningReward / 2;
            maxSupplyForEra =
                maxSupplyForEra +
                (POW_ALLOCATION / (2 ** (rewardEra + 1)));

            emit EraTransition(rewardEra, currentMiningReward);
        }

        unchecked {
            epochCount++;
        }

        if (epochCount % BLOCKS_PER_READJUSTMENT == 0) {
            uint256 ethBlocksSinceLastAdjustment;
            unchecked {
                ethBlocksSinceLastAdjustment =
                    block.number -
                    latestDifficultyPeriodStarted;
            }
            _reAdjustDifficulty(ethBlocksSinceLastAdjustment);
        }

        challengeNumber = blockhash(block.number - 1);
    }

    function _reAdjustDifficulty(uint256 ethBlocksSinceLastPeriod) internal {
        uint256 oldTarget = miningTarget;

        if (ethBlocksSinceLastPeriod < TARGET_BLOCKS_PER_PERIOD) {
            uint256 excessBlockPct = (TARGET_BLOCKS_PER_PERIOD * 100) /
                ethBlocksSinceLastPeriod;
            uint256 excessBlockPctExtra = (excessBlockPct - 100).limitLessThan(
                1000
            );

            unchecked {
                miningTarget -= (miningTarget / 2000) * excessBlockPctExtra;
            }
        } else {
            uint256 shortageBlockPct = (ethBlocksSinceLastPeriod * 100) /
                TARGET_BLOCKS_PER_PERIOD;
            uint256 shortageBlockPctExtra = (shortageBlockPct - 100)
                .limitLessThan(1000);

            unchecked {
                miningTarget += (miningTarget / 2000) * shortageBlockPctExtra;
            }
        }

        if (miningTarget < MINIMUM_TARGET) {
            miningTarget = MINIMUM_TARGET;
        }
        if (miningTarget > MAXIMUM_TARGET) {
            miningTarget = MAXIMUM_TARGET;
        }

        latestDifficultyPeriodStarted = block.number;

        emit DifficultyAdjusted(
            oldTarget,
            miningTarget,
            ethBlocksSinceLastPeriod
        );
    }

    // ========================================================================
    // Linear Vesting Mining Functions
    // ========================================================================

    function submitHashPower(uint256 nonce) external returns (bool success) {
        return _submitHashPower(nonce, msg.sender);
    }

    function submitHashPowerFor(
        uint256 nonce,
        address miner
    ) external returns (bool success) {
        return _submitHashPower(nonce, miner);
    }

    function _submitHashPower(
        uint256 nonce,
        address miner
    ) internal returns (bool) {
        if (miner == address(0)) revert ZeroAddress();

        bytes32 digest = keccak256(
            abi.encodePacked(
                keccak256(abi.encodePacked(challengeNumber, miner, nonce))
            )
        );

        if (uint256(digest) > miningTarget) revert InvalidProofOfWork();
        if (lastRewardEthBlockNumber == block.number)
            revert AlreadyMinedInBlock();

        MinerStake storage stake = minerStakes[miner];

        if (stake.firstSubmissionTime == 0) {
            stake.firstSubmissionTime = block.timestamp;
            stake.lastClaimTime = block.timestamp;
            unchecked {
                totalActiveMiners++;
            }
        }

        unchecked {
            stake.accumulatedHashPower++;
            stake.totalHashPowerSubmitted++;
        }

        lastRewardEthBlockNumber = block.number;
        challengeNumber = blockhash(block.number - 1);

        emit HashPowerSubmitted(miner, 1, stake.accumulatedHashPower);

        return true;
    }

    function claimVestingReward() external returns (uint256 amount) {
        MinerStake storage stake = minerStakes[msg.sender];

        if (stake.firstSubmissionTime == 0) revert InsufficientHashPower();

        uint256 timeSinceLastClaim;
        unchecked {
            timeSinceLastClaim = block.timestamp - stake.lastClaimTime;
        }

        if (timeSinceLastClaim < 1 days) revert TooSoonToClaim();

        uint256 daysPassed = timeSinceLastClaim / 1 days;
        uint256 baseReward = daysPassed * DAILY_VESTING_REWARD;
        uint256 requiredHashPower = daysPassed * REQUIRED_DAILY_HASH_POWER;

        uint256 actualReward = baseReward;
        if (stake.accumulatedHashPower < requiredHashPower) {
            actualReward =
                (baseReward * stake.accumulatedHashPower) /
                requiredHashPower;
        }

        if (totalVestingClaimed + actualReward > VESTING_POOL_ALLOCATION) {
            revert VestingPoolDepleted();
        }

        _mint(msg.sender, actualReward);

        unchecked {
            totalVestingClaimed += actualReward;
            stake.totalVestingClaimed += actualReward;
        }
        stake.lastClaimTime = block.timestamp;
        stake.accumulatedHashPower = 0;

        emit VestingRewardClaimed(
            msg.sender,
            actualReward,
            daysPassed,
            requiredHashPower
        );

        return actualReward;
    }

    // ========================================================================
    // View Functions
    // ========================================================================

    function getChallengeNumber() external view returns (bytes32) {
        return challengeNumber;
    }

    function getMiningTarget() external view returns (uint256) {
        return miningTarget;
    }

    function getMiningDifficulty() external view returns (uint256) {
        return MAXIMUM_TARGET / miningTarget;
    }

    function getMiningReward() external view returns (uint256) {
        return currentMiningReward;
    }

    struct MiningStats {
        uint256 currentReward;
        uint256 difficulty;
        uint256 target;
        uint256 epochCount;
        uint256 rewardEra;
        uint256 tokensMinted;
        uint256 percentMined;
        uint256 blocksUntilAdjustment;
        bytes32 challengeNumber;
        uint256 totalVestingClaimed;
        uint256 vestingPoolRemaining;
        uint256 totalActiveMiners;
    }

    function getMiningStats() external view returns (MiningStats memory stats) {
        stats.currentReward = currentMiningReward;
        stats.difficulty = MAXIMUM_TARGET / miningTarget;
        stats.target = miningTarget;
        stats.epochCount = epochCount;
        stats.rewardEra = rewardEra;
        stats.tokensMinted = tokensMinted;
        stats.percentMined = (tokensMinted * 100) / POW_ALLOCATION;
        stats.blocksUntilAdjustment =
            BLOCKS_PER_READJUSTMENT -
            (epochCount % BLOCKS_PER_READJUSTMENT);
        stats.challengeNumber = challengeNumber;
        stats.totalVestingClaimed = totalVestingClaimed;
        stats.vestingPoolRemaining =
            VESTING_POOL_ALLOCATION -
            totalVestingClaimed;
        stats.totalActiveMiners = totalActiveMiners;
    }

    struct MinerVestingStats {
        uint256 accumulatedHashPower;
        uint256 totalVestingClaimed;
        uint256 totalHashPowerSubmitted;
        uint256 pendingReward;
        uint256 daysSinceLastClaim;
        uint256 requiredHashPowerForFullReward;
        uint256 firstSubmissionTime;
        uint256 lastClaimTime;
    }

    function getMinerVestingStats(
        address miner
    ) external view returns (MinerVestingStats memory stats) {
        MinerStake storage stake = minerStakes[miner];

        stats.accumulatedHashPower = stake.accumulatedHashPower;
        stats.totalVestingClaimed = stake.totalVestingClaimed;
        stats.totalHashPowerSubmitted = stake.totalHashPowerSubmitted;
        stats.firstSubmissionTime = stake.firstSubmissionTime;
        stats.lastClaimTime = stake.lastClaimTime;

        if (stake.lastClaimTime > 0) {
            uint256 timeSinceLastClaim = block.timestamp - stake.lastClaimTime;
            if (timeSinceLastClaim >= 1 days) {
                uint256 daysPassed = timeSinceLastClaim / 1 days;
                uint256 baseReward = daysPassed * DAILY_VESTING_REWARD;
                uint256 requiredHashPower = daysPassed *
                    REQUIRED_DAILY_HASH_POWER;

                stats.daysSinceLastClaim = daysPassed;
                stats.requiredHashPowerForFullReward = requiredHashPower;

                if (stake.accumulatedHashPower >= requiredHashPower) {
                    stats.pendingReward = baseReward;
                } else {
                    stats.pendingReward =
                        (baseReward * stake.accumulatedHashPower) /
                        requiredHashPower;
                }
            }
        }
    }

    function checkMintSolution(
        uint256 nonce,
        address miner
    ) external view returns (bool isValid) {
        bytes32 digest = keccak256(
            abi.encodePacked(
                keccak256(abi.encodePacked(challengeNumber, miner, nonce))
            )
        );
        return uint256(digest) <= miningTarget;
    }

    // ========================================================================
    // Security
    // ========================================================================

    receive() external payable {
        revert ETHNotAccepted();
    }

    fallback() external payable {
        revert ETHNotAccepted();
    }
}
