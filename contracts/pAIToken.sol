// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

//@title pAI Token - Mineable AI-themed ERC20 Token using Proof Of Work + Linear Vesting
//@notice Symbol: pAI | Name: Proof of AI | Decimals: 18
//@dev Total supply: 100,000,000 pAI (49% initial allocation, 51% POW mined)

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
    /**
     * @dev Returns the smaller of two numbers
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Limits a value to be less than a maximum
     */
    function limitLessThan(
        uint256 a,
        uint256 b
    ) internal pure returns (uint256) {
        return a > b ? b : a;
    }
}

library ECRecover {
    /**
     * @notice Recover signer's address from a signed message
     * @param digest Keccak-256 hash digest of the signed message
     * @param v v of the signature
     * @param r r of the signature
     * @param s s of the signature
     * @return Signer address
     */
    function recover(
        bytes32 digest,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal pure returns (address) {
        // Validate signature parameters
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
    /**
     * @notice Make EIP712 domain separator
     */
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

    /**
     * @notice Recover signer's address from an EIP712 signature
     */
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

    // POW Mining State
    uint256 public constant MAXIMUM_SUPPLY = 100_000_000 * 10 ** 18; // 100M pAI
    uint256 public constant INITIAL_ALLOCATION = 49_000_000 * 10 ** 18; // 49M pAI (49%)
    uint256 public constant MINEABLE_SUPPLY = 51_000_000 * 10 ** 18; // 51M pAI (51%)
    uint256 public constant BLOCKS_PER_READJUSTMENT = 2048; // difficulty adjustment period
    uint256 public constant MINIMUM_TARGET = 2 ** 16; // hardest
    uint256 public constant MAXIMUM_TARGET = 2 ** 234; // easiest
    uint256 public constant TARGET_BLOCKS_PER_PERIOD =
        BLOCKS_PER_READJUSTMENT * 40; // Target: 40 ETH blocks per pAI block

    uint256 public miningTarget;
    bytes32 public challengeNumber;
    uint256 public epochCount;
    uint256 public rewardEra;
    uint256 public maxSupplyForEra;
    uint256 public currentMiningReward;
    uint256 public tokensMinted;
    uint256 public latestDifficultyPeriodStarted;
    uint256 public lastRewardEthBlockNumber;

    // Mining Diagnostics
    address public lastRewardTo;
    uint256 public lastRewardAmount;

    // Initial allocation recipient (will renounce after receiving)
    address public immutable initialRecipient;

    // ========================================================================
    // Linear Vesting Mining System
    // ========================================================================

    /// @notice Daily vesting reward per active miner
    uint256 public constant DAILY_VESTING_REWARD = 0.5 * 10 ** 18; // 0.5 pAI/day

    /// @notice Minimum hash power submissions required per day to claim full reward
    uint256 public constant REQUIRED_DAILY_HASH_POWER = 10;

    /// @notice Vesting pool allocation (from mineable supply)
    uint256 public constant VESTING_POOL_ALLOCATION = 10_000_000 * 10 ** 18; // 10M pAI (19.6% of mineable)

    /// @notice Traditional PoW allocation (remaining mineable supply)
    uint256 public constant POW_ALLOCATION = 41_000_000 * 10 ** 18; // 41M pAI (80.4% of mineable)

    /// @notice Total vesting rewards claimed
    uint256 public totalVestingClaimed;

    /// @notice Miner stake information
    struct MinerStake {
        uint256 lastClaimTime; // Last time miner claimed vesting rewards
        uint256 accumulatedHashPower; // Accumulated valid PoW submissions since last claim
        uint256 totalVestingClaimed; // Total vesting rewards claimed by miner
        uint256 totalHashPowerSubmitted; // Lifetime hash power submissions
        uint256 firstSubmissionTime; // First time miner submitted hash power
    }

    mapping(address => MinerStake) public minerStakes;

    /// @notice Total active miners (ever submitted at least once)
    uint256 public totalActiveMiners;

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

    // Vesting events
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

        // Initialize EIP-712 domain separator
        DOMAIN_SEPARATOR = EIP712.makeDomainSeparator(
            name,
            version,
            address(this)
        );

        // Mint 49% initial allocation
        _mint(_initialRecipient, INITIAL_ALLOCATION);
        emit InitialAllocation(_initialRecipient, INITIAL_ALLOCATION);

        // Initialize mining parameters for remaining 51%
        miningTarget = MAXIMUM_TARGET;
        challengeNumber = blockhash(block.number - 1);
        rewardEra = 0;
        currentMiningReward = 100 * 10 ** decimals; // Initial: 100 pAI per block

        // Adjust max supply for era to account for vesting pool
        maxSupplyForEra = INITIAL_ALLOCATION + (POW_ALLOCATION / 2); // 49M + 20.5M = 69.5M

        latestDifficultyPeriodStarted = block.number;
        epochCount = 0;
        tokensMinted = 0; // Only counts traditional PoW mined tokens
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

    /**
     * @notice Mine new pAI tokens with Proof of Work (traditional instant reward)
     * @param nonce The mining nonce that satisfies the difficulty requirement
     * @return success Whether the mining was successful
     */
    function mint(uint256 nonce) external returns (bool success) {
        return _mintTo(nonce, msg.sender);
    }

    /**
     * @notice Mine new pAI tokens to a specific address
     * @param nonce The mining nonce
     * @param minter Address to receive the mining reward
     * @return success Whether the mining was successful
     */
    function mintTo(
        uint256 nonce,
        address minter
    ) external returns (bool success) {
        return _mintTo(nonce, minter);
    }

    function _mintTo(uint256 nonce, address minter) internal returns (bool) {
        if (minter == address(0)) revert ZeroAddress();

        // Verify Proof of Work
        bytes32 digest = keccak256(
            abi.encodePacked(
                keccak256(abi.encodePacked(challengeNumber, minter, nonce))
            )
        );

        if (uint256(digest) > miningTarget) revert InvalidProofOfWork();

        // Prevent double mining in same block
        if (lastRewardEthBlockNumber == block.number)
            revert AlreadyMinedInBlock();

        // Check supply cap (using POW_ALLOCATION instead of MINEABLE_SUPPLY)
        if (tokensMinted + currentMiningReward > maxSupplyForEra) {
            revert MaxSupplyExceeded();
        }

        // Mint reward
        _mint(minter, currentMiningReward);

        unchecked {
            tokensMinted += currentMiningReward;
        }

        // Update diagnostics
        lastRewardTo = minter;
        lastRewardAmount = currentMiningReward;
        lastRewardEthBlockNumber = block.number;

        // Start new epoch
        _startNewMiningEpoch();

        emit Mint(minter, currentMiningReward, epochCount, challengeNumber);

        return true;
    }

    /**
     * @dev Start a new mining epoch and adjust difficulty if needed
     */
    function _startNewMiningEpoch() internal {
        // Check for era transition (halving) - only for traditional PoW allocation
        if (
            totalSupply + currentMiningReward > maxSupplyForEra && rewardEra < 7
        ) {
            unchecked {
                rewardEra++;
            }

            currentMiningReward = (100 * 10 ** decimals) / (2 ** rewardEra);
            maxSupplyForEra =
                INITIAL_ALLOCATION +
                POW_ALLOCATION -
                (POW_ALLOCATION / (2 ** (rewardEra + 1)));

            emit EraTransition(rewardEra, currentMiningReward);
        }

        unchecked {
            epochCount++;
        }

        // Adjust difficulty every BLOCKS_PER_READJUSTMENT epochs
        if (epochCount % BLOCKS_PER_READJUSTMENT == 0) {
            uint256 ethBlocksSinceLastAdjustment;
            unchecked {
                ethBlocksSinceLastAdjustment =
                    block.number -
                    latestDifficultyPeriodStarted;
            }
            _reAdjustDifficulty(ethBlocksSinceLastAdjustment);
        }

        // Update challenge number
        challengeNumber = blockhash(block.number - 1);
    }

    /**
     * @dev Adjust mining difficulty based on actual vs target block time
     */
    function _reAdjustDifficulty(uint256 ethBlocksSinceLastPeriod) internal {
        uint256 oldTarget = miningTarget;

        if (ethBlocksSinceLastPeriod < TARGET_BLOCKS_PER_PERIOD) {
            // Mining too fast - increase difficulty (decrease target)
            uint256 excessBlockPct = (TARGET_BLOCKS_PER_PERIOD * 100) /
                ethBlocksSinceLastPeriod;
            uint256 excessBlockPctExtra = (excessBlockPct - 100).limitLessThan(
                1000
            );

            unchecked {
                miningTarget -= (miningTarget / 2000) * excessBlockPctExtra; // Max 50% decrease
            }
        } else {
            // Mining too slow - decrease difficulty (increase target)
            uint256 shortageBlockPct = (ethBlocksSinceLastPeriod * 100) /
                TARGET_BLOCKS_PER_PERIOD;
            uint256 shortageBlockPctExtra = (shortageBlockPct - 100)
                .limitLessThan(1000);

            unchecked {
                miningTarget += (miningTarget / 2000) * shortageBlockPctExtra; // Max 50% increase
            }
        }

        // Enforce bounds
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

    /**
     * @notice Submit hash power proof without receiving immediate reward
     * @dev Miners accumulate hash power to claim vesting rewards later
     * @param nonce The mining nonce that satisfies the difficulty requirement
     * @return success Whether the submission was successful
     */
    function submitHashPower(uint256 nonce) external returns (bool success) {
        return _submitHashPower(nonce, msg.sender);
    }

    /**
     * @notice Submit hash power for another address
     * @param nonce The mining nonce
     * @param miner Address to credit the hash power to
     * @return success Whether the submission was successful
     */
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

        // Verify Proof of Work (same difficulty as traditional mining)
        bytes32 digest = keccak256(
            abi.encodePacked(
                keccak256(abi.encodePacked(challengeNumber, miner, nonce))
            )
        );

        if (uint256(digest) > miningTarget) revert InvalidProofOfWork();

        // Prevent double submission in same block
        if (lastRewardEthBlockNumber == block.number)
            revert AlreadyMinedInBlock();

        MinerStake storage stake = minerStakes[miner];

        // Track first-time miners
        if (stake.firstSubmissionTime == 0) {
            stake.firstSubmissionTime = block.timestamp;
            stake.lastClaimTime = block.timestamp;
            unchecked {
                totalActiveMiners++;
            }
        }

        // Increment hash power
        unchecked {
            stake.accumulatedHashPower++;
            stake.totalHashPowerSubmitted++;
        }

        // Update last mining block (prevent double mining)
        lastRewardEthBlockNumber = block.number;

        // Update challenge for next submission
        challengeNumber = blockhash(block.number - 1);

        emit HashPowerSubmitted(miner, 1, stake.accumulatedHashPower);

        return true;
    }

    /**
     * @notice Claim accumulated vesting rewards based on time and hash power
     * @dev Calculates rewards linearly: days_passed * DAILY_VESTING_REWARD
     * @return amount Amount of pAI claimed
     */
    function claimVestingReward() external returns (uint256 amount) {
        MinerStake storage stake = minerStakes[msg.sender];

        // Must have submitted at least once
        if (stake.firstSubmissionTime == 0) revert InsufficientHashPower();

        // Calculate time passed since last claim
        uint256 timeSinceLastClaim;
        unchecked {
            timeSinceLastClaim = block.timestamp - stake.lastClaimTime;
        }

        if (timeSinceLastClaim < 1 days) revert TooSoonToClaim();

        uint256 daysPassed = timeSinceLastClaim / 1 days;

        // Calculate base reward (linear vesting)
        uint256 baseReward = daysPassed * DAILY_VESTING_REWARD;

        // Calculate required hash power for full reward
        uint256 requiredHashPower = daysPassed * REQUIRED_DAILY_HASH_POWER;

        // Apply hash power penalty if insufficient
        uint256 actualReward = baseReward;
        if (stake.accumulatedHashPower < requiredHashPower) {
            // Proportional reduction: (actual / required) * baseReward
            actualReward =
                (baseReward * stake.accumulatedHashPower) /
                requiredHashPower;
        }

        // Check vesting pool availability
        if (totalVestingClaimed + actualReward > VESTING_POOL_ALLOCATION) {
            revert VestingPoolDepleted();
        }

        // Mint vesting reward
        _mint(msg.sender, actualReward);

        // Update state
        unchecked {
            totalVestingClaimed += actualReward;
            stake.totalVestingClaimed += actualReward;
        }
        stake.lastClaimTime = block.timestamp;
        stake.accumulatedHashPower = 0; // Reset hash power counter

        emit VestingRewardClaimed(
            msg.sender,
            actualReward,
            daysPassed,
            stake.accumulatedHashPower
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

    /**
     * @notice Get comprehensive mining statistics
     */
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

    /**
     * @notice Get miner's vesting statistics
     * @param miner Address of the miner
     */
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
            stats.daysSinceLastClaim = timeSinceLastClaim / 1 days;

            if (stats.daysSinceLastClaim > 0) {
                uint256 baseReward = stats.daysSinceLastClaim *
                    DAILY_VESTING_REWARD;
                stats.requiredHashPowerForFullReward =
                    stats.daysSinceLastClaim *
                    REQUIRED_DAILY_HASH_POWER;

                // Calculate pending reward with hash power penalty
                if (
                    stake.accumulatedHashPower <
                    stats.requiredHashPowerForFullReward
                ) {
                    stats.pendingReward =
                        (baseReward * stake.accumulatedHashPower) /
                        stats.requiredHashPowerForFullReward;
                } else {
                    stats.pendingReward = baseReward;
                }
            }
        }
    }

    /**
     * @notice Check if a nonce would be a valid solution
     * @param nonce The nonce to test
     * @param miner The miner address
     * @return isValid Whether this would be a valid solution
     */
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
