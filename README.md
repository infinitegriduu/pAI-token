# pAI Whitepaper

#### (Whitepaper Revision 1.0)

#### pAI: Decentralized Artificial Intelligence Token — Dual-Track Mining Innovation Model

---

## Abstract

The Ethereum network has proven itself to be the world's first permissionless, transparent, and tamper-proof software application ecosystem. The emergence of smart contracts has enabled anyone to deploy decentralized applications and achieve interoperability through standard protocols such as ERC20.

However, traditional ERC20 token distribution methods primarily rely on **ICO/airdrops**, which are easily classified as securities and face centralization risks. In contrast, Bitcoin employs **Proof of Work (PoW) mining** for distribution and is classified as a "commodity."

**pAI** (Proof of AI Token) aims to **combine artificial intelligence with blockchain**, becoming a **decentralized AI token in the Ethereum ecosystem**. It innovatively adopts a **dual-track mining mechanism**:

- **Traditional PoW Mining (40M pAI, 26.67%)**: Provides instant rewards, attracting professional miners
- **Linear Vesting Mining (10M pAI, 6.67%)**: Incentivizes long-term participation, building a stable community
- **Initial Market Allocation (100M pAI, 66.67%)**: Ensures liquidity and application deployment

This enables pAI to possess both **market-driving power** and retain the **security and community-driven nature of decentralized mining**, while achieving fair incentives for long-term holders through an innovative linear release mechanism.

---

## Background

pAI is an ERC20 token written in Solidity 0.8.30, aiming to become a **decentralized AI-native asset**.

Unlike traditional tokens that rely on foundation or company management, pAI **has no pre-mining or ICO**, but is instead governed and distributed through **publicly transparent smart contracts**.

We believe:

- **Artificial Intelligence + Blockchain** is the core combination of the future
- A decentralized architecture enables developers and users worldwide to share the benefits of the AI economy
- As an "AI-native token," pAI will circulate in multiple scenarios such as **computing power, AI training data, model exchange, and decentralized applications**

### The Importance of Decentralized Tokens

Due to the obvious high failure rate of the current Ethereum ICO market, investors are vulnerable to pseudo-values supported only by speculation. pAI mitigates this problem by providing the Ethereum network with a decentralized Bitcoin-like asset that can serve as numerous centralized tokens in a more inviolable and trustless format.

This powerful mechanism frees individuals from the need to use third-party exchanges prone to security vulnerabilities and wallet breaches, as well as third-party custodians. Moving away from centralization was the core concept of Satoshi Nakamoto in the original Bitcoin. pAI has the ability to help keep every step of the Ethereum ecosystem's value transfer process open, accountable, trustless, and decentralized. Unlike Bitcoin, pAI can interact with decentralized exchanges like Uniswap and SushiSwap because it is fully compatible with Ethereum smart contracts. This means that while Bitcoin can only be traded through centralized methods, pAI can be traded permissionlessly in immutable permanent smart contracts that cannot be censored or restricted by central entities.

---

## Name Origin

The meaning of "pAI":

- "p" represents **Proof (Evidence)** and **People (Community)**
- "AI" represents **Artificial Intelligence**, symbolizing the next generation of intelligence-driven economy

---

## Token Economics Model (Tokenomics)

### Overall Supply Structure

**Total Supply: 150,000,000 pAI (150 Million)**

```
Total Supply: 150M pAI
├── Initial Allocation: 100M (66.67%) - Immediate minting for liquidity and ecosystem building
└── Minable Supply: 50M (33.33%) - Community mining release
    ├── Traditional PoW: 40M (80% of minable portion)
    └── Linear Vesting Pool: 10M (20% of minable portion)
```

### Allocation Methods Detailed

#### 1. Initial Allocation (100M pAI, 66.67%)

- **Purpose**: Establish liquidity, incentivize early applications, support ecosystem development
- **Release Method**: One-time minting at contract deployment
- **Uses**:
  - Decentralized Exchange (DEX) liquidity pools
  - Strategic partner incentives
  - Community building and ecosystem development
  - Early user incentives for AI applications

#### 2. Traditional PoW Mining (40M pAI, 26.67%)

- **Purpose**: Decentralized distribution, ensuring token fairness
- **Mechanism**: Proof of Work (Keccak256)
- **Characteristics**: Instant rewards, suitable for professional miners
- **Initial Reward**: 100 pAI/epoch
- **Halving Mechanism**: 7 halvings, expected to last 100 years

**Reward Halving Schedule:**

```
Era 0: 100 pAI   → Target Supply: 120M (100M + 20M)
Era 1: 50 pAI    → Target Supply: 130M (100M + 30M)
Era 2: 25 pAI    → Target Supply: 135M (100M + 35M)
Era 3: 12.5 pAI  → Target Supply: 137.5M
Era 4: 6.25 pAI  → Target Supply: 138.75M
Era 5: 3.125 pAI → Target Supply: 139.375M
Era 6: 1.5625 pAI → Target Supply: 139.6875M
Era 7: 0.78125 pAI → Target Supply: 140M (Final)
```

#### 3. Linear Vesting Mining (10M pAI, 6.67%) — Innovation Mechanism 🌟

- **Purpose**: Incentivize long-term participation, build a stable community
- **Mechanism**: Hash power accumulation + time-based release
- **Characteristics**: Delayed rewards, suitable for long-term holders
- **Daily Reward**: 0.5 pAI/day/miner
- **Requirement**: Submit at least 10 valid hash power proofs per day

**Linear Vesting Workflow:**

```
1. Miner submits hash power proof (submitHashPower)
   ├─ Verify PoW (same difficulty as traditional mining)
   └─ No immediate reward

2. Time Accumulation (minimum 1 day)
   └─ daysPassed = (current time - last claim) / 1 day

3. Claim Vesting Reward (claimVestingReward)
   ├─ baseReward = daysPassed × 0.5 pAI
   ├─ requiredHashPower = daysPassed × 10
   └─ actualReward = baseReward × (submitted power / required power)
```

**Hash Power Penalty Mechanism Examples:**

```
Scenario 1: Sufficient Hash Power ✅
- Elapsed: 10 days
- Required: 10 × 10 = 100 submissions
- Actual: 120 submissions
- Reward: 10 × 0.5 = 5 pAI (Full amount)

Scenario 2: Insufficient Hash Power ⚠️
- Elapsed: 10 days  
- Required: 10 × 10 = 100 submissions
- Actual: 50 submissions
- Reward: 5 × (50/100) = 2.5 pAI (Halved)

Scenario 3: Minimal Hash Power ❌
- Elapsed: 30 days
- Required: 30 × 10 = 300 submissions
- Actual: 30 submissions
- Reward: 15 × (30/300) = 1.5 pAI (Only 10%)
```

### Economic Model Advantages

This design ensures:

- **Liquidity**: 66.67% released early, quickly entering DeFi and application ecosystems
- **Fairness**: 33.33% distributed through hash power competition, avoiding monopoly by few
- **Longevity**: 10M linear vesting pool incentivizes sustained participation
- **Stability**: Dual-track satisfies different types of miners' needs

---

## Mining Mechanism Explained

### Traditional PoW Mining

#### Mining Algorithm

pAI uses dual Keccak256 (SHA3) hashing for mining, similar to Bitcoin's dual SHA256:

```solidity
// First layer hash
bytes32 innerHash = keccak256(
    abi.encodePacked(challengeNumber, minerAddress, nonce)
);

// Second layer hash
bytes32 digest = keccak256(
    abi.encodePacked(innerHash)
);

// Verification
require(uint256(digest) <= miningTarget, "InvalidProofOfWork");
```

**Parameter Explanation:**

- **nonce**: Random number selected by mining software
- **minerAddress**: Ethereum address of the miner, preventing MITM attacks and supporting pool mining
- **challengeNumber**: Most recent Ethereum block hash, updated each round to prevent pre-mining
- **miningTarget**: Difficulty target, automatically decreases as network hash power increases

#### Difficulty Adjustment Mechanism

**Adjustment Period**: Every 2048 epochs
**Target Rate**: 40 Ethereum blocks = 1 pAI epoch (~8 minutes)
**Adjustment Range**: ±50% (maximum change)
**Difficulty Range**: `2^16` (hardest) ~ `2^234` (easiest)

```solidity
// Mining too fast → increase difficulty
if (ethBlocks < TARGET_BLOCKS_PER_PERIOD) {
    uint256 excessPct = ((TARGET - ethBlocks) * 1000) / TARGET;
    miningTarget -= decrease; // Reduce by maximum 50%
}

// Mining too slow → decrease difficulty  
else {
    uint256 shortagePct = ((ethBlocks - TARGET) * 1000) / TARGET;
    miningTarget += increase; // Increase by maximum 50%
}
```

#### Double Spending Prevention

```solidity
// Can only mine once per Ethereum block
if (lastRewardEthBlockNumber == block.number) 
    revert AlreadyMinedInBlock();
```

### Linear Vesting Mining

#### Core Parameters

```solidity
DAILY_VESTING_REWARD = 0.5 pAI        // Daily base reward
REQUIRED_DAILY_HASH_POWER = 10         // Hash power submissions required for full reward
VESTING_POOL_ALLOCATION = 10,000,000 pAI  // Total vesting pool amount
```

#### Miner State Tracking

```solidity
struct MinerStake {
    uint256 lastClaimTime;              // Last claim time
    uint256 accumulatedHashPower;       // Accumulated hash power count
    uint256 totalVestingClaimed;        // Total vesting rewards claimed
    uint256 totalHashPowerSubmitted;    // Total hash power submissions
    uint256 firstSubmissionTime;        // First submission time
}
```

#### Key Functions

**1. submitHashPower(uint256 nonce)**

- Verify proof of work (same difficulty as traditional mining)
- Accumulate miner hash power count
- Initialize new miner state
- Trigger HashPowerSubmitted event

**2. claimVestingReward()**

- Check if 1 day has passed
- Calculate days and required hash power
- Calculate reward based on actual hash power ratio
- Reset hash power counter
- Distribute reward and trigger VestingRewardClaimed event

#### Economic Incentive Analysis

**Theoretical Maximum Output:**

```
Maximum active miners: 10,000,000 / 0.5 = 20,000,000 days = 54,794 years
```

**Real-World Scenarios:**

```
- 1,000 active miners: 500 pAI/day (depletion time: 54.8 years)
- 10,000 active miners: 5,000 pAI/day (depletion time: 5.5 years)
- 50,000 active miners: 25,000 pAI/day (depletion time: 1.1 years)
```

### Mining Cost-Benefit Comparison

| Feature | Traditional PoW Mining | Linear Vesting Mining |
|---------|---------------------|-----------------------|
| Reward Timing | ⚡ Instant | ⏰ Delayed (minimum 1 day) |
| Suitable For | 👨‍💻 Professional Miners | 👥 Long-term Holders |
| Competition Level | 🔥 Intense | ❄️ Moderate |
| Hash Power Requirement | 📈 Continuous High | 📊 Low-Frequency |
| Revenue Model | 💰 High Risk/High Reward | 💵 Stable Passive Income |
| Gas Cost | 💸 Higher (~60,000) | 💲 Lower (~30,000) |

---

## Account System and Security Features

### ERC20 Standard Compliance

pAI fully implements the ERC20 standard, compatible with all Ethereum wallets and DeFi protocols:

- Metamask
- Ledger Nano
- Trezor
- Trust Wallet
- imToken
- And any wallet supporting ERC20

### EIP-2612 Permit Support

pAI implements the EIP-2612 standard, supporting gas-free authorization:

```solidity
function permit(
    address owner,
    address spender,
    uint256 value,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
) external;
```

**Advantages:**

- Users don't need to pre-approve
- Save gas for one transaction
- Improved user experience

### Security Mechanisms

#### 1. Custom Errors (Gas Optimization)

```solidity
error InvalidProofOfWork();        // Invalid proof of work
error AlreadyMinedInBlock();       // Duplicate mining in same block
error MaxSupplyExceeded();         // Maximum supply exceeded
error VestingPoolDepleted();       // Vesting pool depleted
error TooSoonToClaim();            // Claim time not reached
error InsufficientHashPower();     // Insufficient hash power
error ZeroAddress();               // Zero address
error InsufficientBalance();       // Insufficient balance
error InsufficientAllowance();     // Insufficient allowance
error PermitExpired();             // Permit expired
error InvalidSignature();          // Invalid signature
error ETHNotAccepted();            // ETH not accepted
```

#### 2. Reentrancy Protection

Uses "Check-Effect-Interaction" pattern:

```solidity
// ✅ Safe pattern
tokensMinted += reward;          // 1. Update state first
_mint(miner, reward);            // 2. Then mint tokens
challengeNumber = blockhash(block.number - 1);  // 3. Update challenge
```

#### 3. Overflow Protection

Solidity 0.8.30 enables overflow checking by default, use unchecked only in safe places:

```solidity
unchecked {
    // Only use where overflow is impossible
    stake.accumulatedHashPower++;
    epochCount++;
}
```

#### 4. Access Control

```solidity
// Reject direct ETH transfers
receive() external payable {
    revert ETHNotAccepted();
}

fallback() external payable {
    revert ETHNotAccepted();
}
```

---

## Pool Mining

When mining pAI, miners must pay a small amount of gas for each solution submission to execute the smart contract's mint() or submitHashPower() function. To alleviate the gas burden, miners can choose to join a mining pool.

### Pool Operation

**Traditional PoW Pools:**

- Pool submits solutions on behalf of miners and pays gas fees
- Pools typically charge a small percentage of rewards, with the remainder going to miners providing PoW solutions
- Since the miner's Ethereum address is included in the proof of work, miners must use the pool's Ethereum address for mining
- Pools accept "partial solutions," miners receive "shares" from the pool for solutions that are close but not fully valid

**Linear Vesting Pools:**

- Pools can submit hash power proofs on behalf of miners
- Accumulated hash power belongs to the miner's own address
- Miners can claim vesting rewards independently
- Reduces gas costs for individual miners

This mechanism follows the same methodology as Bitcoin and Ethereum Proof of Work pool mining.

---

## Smart Contract Interface

### Core State Variables

```solidity
// ERC20 Basics
string public constant name = "Proof of AI";
string public constant symbol = "pAI";
uint8 public constant decimals = 18;
uint256 public totalSupply;

// Supply Constants
uint256 public constant MAXIMUM_SUPPLY = 150_000_000 * 10**18;
uint256 public constant INITIAL_ALLOCATION = 100_000_000 * 10**18;
uint256 public constant MINEABLE_SUPPLY = 50_000_000 * 10**18;
uint256 public constant POW_ALLOCATION = 40_000_000 * 10**18;
uint256 public constant VESTING_POOL_ALLOCATION = 10_000_000 * 10**18;

// Mining Parameters
uint256 public constant BLOCKS_PER_READJUSTMENT = 2048;
uint256 public constant MINIMUM_TARGET = 2**16;
uint256 public constant MAXIMUM_TARGET = 2**234;
uint256 public constant TARGET_BLOCKS_PER_PERIOD = 2048 * 40;

// Linear Vesting Parameters
uint256 public constant DAILY_VESTING_REWARD = 0.5 * 10**18;
uint256 public constant REQUIRED_DAILY_HASH_POWER = 10;
```

### ERC20 Standard Methods

```solidity
function balanceOf(address account) external view returns (uint256);
function transfer(address to, uint256 amount) external returns (bool);
function approve(address spender, uint256 amount) external returns (bool);
function transferFrom(address from, address to, uint256 amount) external returns (bool);
function allowance(address owner, address spender) external view returns (uint256);
```

### Traditional PoW Mining Methods

```solidity
// Core mining functions
function mint(uint256 nonce) external returns (bool);
function mintTo(uint256 nonce, address minter) external returns (bool);

// Query methods
function getChallengeNumber() external view returns (bytes32);
function getMiningDifficulty() external view returns (uint256);
function getMiningTarget() external view returns (uint256);
function getMiningReward() external view returns (uint256);

// Verification methods
function checkMintSolution(
    uint256 nonce,
    address miner
) external view returns (bool);
```

### Linear Vesting Mining Methods

```solidity
// Submit hash power proof
function submitHashPower(uint256 nonce) external returns (bool);
function submitHashPowerFor(uint256 nonce, address miner) external returns (bool);

// Claim vesting rewards
function claimVestingReward() external returns (uint256);

// Query methods
function getMinerVestingStats(address miner) external view returns (
    uint256 lastClaimTime,
    uint256 accumulatedHashPower,
    uint256 totalVestingClaimed,
    uint256 totalHashPowerSubmitted,
    uint256 firstSubmissionTime,
    uint256 daysSinceLastClaim,
    uint256 requiredHashPowerForFullReward,
    uint256 pendingReward
);
```

### Statistics Query Methods

```solidity
function getMiningStats() external view returns (
    uint256 currentReward,
    uint256 difficulty,
    uint256 target,
    uint256 epochCount,
    uint256 rewardEra,
    uint256 tokensMinted,
    uint256 percentMined,
    uint256 blocksUntilAdjustment,
    bytes32 challengeNumber,
    uint256 totalVestingClaimed,
    uint256 vestingPoolRemaining,
    uint256 totalActiveMiners
);
```

### Event Definitions

```solidity
// ERC20 Standard Events
event Transfer(address indexed from, address indexed to, uint256 value);
event Approval(address indexed owner, address indexed spender, uint256 value);

// Mining Events
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

// Linear Vesting Events
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
```

---

## Use Cases

### 1. AI Economy Payment and Incentives

- **AI Computing Market**: Users use pAI to rent GPU/TPU computing power for AI training
- **Model Trading Market**: Developers purchase pre-trained AI models using pAI
- **Dataset Trading**: Data providers sell high-quality training data for pAI
- **AI Service Payment**: DApp users use pAI to pay for AI inference services

### 2. DeFi Ecosystem Integration

- **Collateral Lending**: pAI serves as collateral in lending protocols like Aave and Compound
- **Liquidity Mining**: Provide pAI/ETH and pAI/USDC liquidity to earn rewards
- **Yield Aggregators**: Automatically optimize pAI DeFi yield strategies
- **Derivatives Trading**: Futures and options trading based on pAI

### 3. Cross-Chain and AI Marketplaces

- **Cross-Chain Bridges**: Bridge pAI to other chains via LayerZero and Axelar
- **Multi-Chain Deployment**: Deploy on L2s like Polygon, Arbitrum, and Optimism
- **Decentralized AI Markets**: Establish cross-chain AI model and service marketplaces
- **Interoperability**: Achieve interoperability with other AI token projects

### 4. Ethereum Ecosystem Value Storage

- **Value Storage**: pAI serves as the primary exchange medium and value store in the Ethereum network
- **Network Security**: Allows Ether to focus on its original function — securing the network
- **Ecosystem Position**: Acts as the "Bitcoin of Ethereum ecosystem" with all Bitcoin characteristics
- **Combined Advantages**: Combines Ethereum network speed and scalability benefits

### 5. Community Governance and Incentives

- **Community Proposals**: Holders can participate in governance voting using pAI
- **Contribution Incentives**: Reward developers and users contributing to the ecosystem
- **Ecosystem Fund**: Establish ecosystem development fund from initial allocation
- **Partner Incentives**: Incentivize AI projects and applications to integrate pAI

---

## Technical Innovation Highlights

### 1. Dual-Track Mining Design 🎯

- **Immediate Satisfaction**: Traditional PoW satisfies professional miner needs
- **Long-term Incentives**: Linear vesting encourages sustained participation
- **Flexible Choice**: Miners can participate in both mining types
- **Risk Diversification**: Reduces risk of single mining mode dependence

### 2. Hash Power Proof Separation Mechanism 🔄

- **Submission vs. Reward Separation**: Submitting power ≠ immediate reward
- **Time Lock**: Minimum 1-day waiting period
- **Hash Power Accumulation**: Encourages continuous participation
- **Fair Distribution**: Prevents hash power monopoly

### 3. Adaptive Difficulty Adjustment ⚖️

- **Precise Adjustment**: Adjusts every 2048 epochs
- **Target Rate**: Maintains 8-minute block time
- **Range Limitation**: ±50% maximum change
- **Network Stability**: Automatically adapts to hash power changes

### 4. Gas Optimization Strategy ⛽

- **Custom Errors**: Save ~50% gas compared to require + string
- **Unchecked Arithmetic**: Use in safe places to save gas
- **Event Optimization**: Streamline event parameters
- **State Variable Optimization**: Reasonable use of storage and memory

### 5. Security Protection Mechanisms 🛡️

- **Reentrancy Protection**: CEI pattern prevents reentrancy attacks
- **Overflow Protection**: Solidity 0.8.30 default overflow checking
- **Double Spending Prevention**: Only mine once per block
- **Signature Verification**: EIP-712 standard signature verification

---

## Deep Economic Model Analysis

### Inflation Rate Calculation

#### Traditional PoW Portion

**Assumptions:**

- 40 ETH blocks = 1 pAI epoch (~8 minutes)
- Daily epochs = 24 × 60 / 8 = 180 epochs

**Daily Production per Era:**

```
Era 0: 180 × 100 = 18,000 pAI/day
Era 1: 180 × 50 = 9,000 pAI/day
Era 2: 180 × 25 = 4,500 pAI/day
Era 3: 180 × 12.5 = 2,250 pAI/day
Era 4: 180 × 6.25 = 1,125 pAI/day
Era 5: 180 × 3.125 = 562.5 pAI/day
Era 6: 180 × 1.5625 = 281.25 pAI/day
Era 7: 180 × 0.78125 = 140.625 pAI/day
```

**Annualized Inflation Rate (relative to circulation):**

```
Era 0: (18,000 × 365) / 100M = 6.57% (first year)
Era 1: (9,000 × 365) / 120M = 2.74%
Era 2: (4,500 × 365) / 130M = 1.26%
...
```

#### Linear Vesting Portion

**Maximum Theoretical Output:**

```
Active miners × 0.5 pAI/day
```

**Real-World Scenario Analysis:**

```
┌─────────────┬──────────────┬────────────────┬──────────────┐
│ Active Miners│ Daily Output │ Annual Output  │ Depletion    │
├─────────────┼──────────────┼────────────────┼──────────────┤
│ 1,000       │ 500 pAI      │ 182,500 pAI    │ 54.8 years   │
│ 5,000       │ 2,500 pAI    │ 912,500 pAI    │ 11.0 years   │
│ 10,000      │ 5,000 pAI    │ 1,825,000 pAI  │ 5.5 years    │
│ 50,000      │ 25,000 pAI   │ 9,125,000 pAI  │ 1.1 years    │
└─────────────┴──────────────┴────────────────┴──────────────┘
```

### Mining Revenue Model

#### Traditional PoW Revenue

**Daily Miner Revenue:**

```
Daily Revenue = (Miner Hash Power / Network Hash Power) × Daily Output × Success Rate
```

**Example Calculation:**

```
Assumptions:
- Miner hash power: 100 MH/s
- Network hash power: 10 GH/s (10,000 MH/s)
- Era 0 daily output: 18,000 pAI
- Success rate: 95%

Daily Revenue = (100 / 10,000) × 18,000 × 0.95 = 171 pAI/day
Monthly Revenue = 171 × 30 = 5,130 pAI/month
```

#### Linear Vesting Revenue

**Full Reward Conditions:**

```
Submit ≥ 10 valid hash power proofs per day
```

**Revenue Calculation:**

```
Maximum daily revenue = 0.5 pAI
Maximum monthly revenue = 0.5 × 30 = 15 pAI
Maximum annual revenue = 0.5 × 365 = 182.5 pAI
```

**Insufficient Hash Power Penalty:**

```
Actual Revenue = Base Revenue × (Actual Hash Power Submissions / Required Submissions)
```

### Total Revenue Comparison

**Professional Miner Strategy:**

- Primarily participate in traditional PoW (high hash power investment)
- Supplement with linear vesting (low-frequency submissions)
- Expected monthly revenue: 5,000+ pAI

**Regular Holder Strategy:**

- Primarily participate in linear vesting (low-cost participation)
- Occasionally participate in traditional PoW (luck-based)
- Expected monthly revenue: 15-50 pAI

---

## Mining Hash Power Calculation

### Hash Power Units

```
1 KH/s = 1,000 hashes/second
1 MH/s = 1,000,000 hashes/second
1 GH/s = 1,000,000,000 hashes/second
1 TH/s = 1,000,000,000,000 hashes/second
```

### Block Solution Time Calculation

```solidity
Block Solution Time (seconds) = (Difficulty × 2^22) / Hash Power (hashes/second)
```

**Example:**

```
Assumptions:
- Current Difficulty: 1,000,000
- Miner Hash Power: 100 MH/s = 100,000,000 H/s

Solution Time = (1,000,000 × 2^22) / 100,000,000
              = (1,000,000 × 4,194,304) / 100,000,000
              ≈ 41.9 seconds
```

### Success Rate Calculation

```
Success probability per attempt = miningTarget / 2^256
Attempts per second = Hash Power (H/s)
Expected Solution Time = 1 / (Success probability × Attempts per second)
```

---

## Roadmap

### Phase 1: Launch Stage (Q1 2025)

- ✅ Smart contract development complete
- ✅ Security audit
- ✅ Testnet deployment
- 🔄 Mainnet deployment
- 🔄 Initial liquidity pool establishment
- 🔄 Miner community formation

### Phase 2: Ecosystem Building (Q2-Q3 2025)

- Mining pool software development
- Block explorer launch
- DEX liquidity incentives
- First AI DApp integrations
- Community governance launch

### Phase 3: Application Deployment (Q4 2025 - Q1 2026)

- AI computing market launch
- Model trading market Beta
- Cross-chain bridge deployment
- L2 expansion solutions
- Partner ecosystem expansion

### Phase 4: Ecosystem Prosperity (2026+)

- Full multi-chain deployment
- Mature AI service ecosystem
- Deep DeFi integration
- Improved decentralized governance
- Global community expansion

---

## Risks and Challenges

### Technical Risks

#### 1. Ethereum Network Dependency

**Risk Description:**  
High gas fees or network congestion may impact mining efficiency and user experience.

**Mitigation Measures:**

- Optimize contract gas consumption
- Support L2 expansion solutions (Arbitrum, Optimism)
- Develop batch submission functionality

#### 2. Smart Contract Security

**Risk Description:**  
Potential contract vulnerabilities may lead to fund loss.

**Mitigation Measures:**

- Multiple security audits
- Bug Bounty program
- Community oversight and code review

#### 3. Transaction Rollback During Difficulty Adjustment Periods

**Risk Description:**  
Multiple valid solutions may be submitted in short timeframe when difficulty is too low relative to hash power, potentially causing transaction rollbacks.

**Mitigation Measures:**

- Double spending prevention mechanism
- Pool coordination
- Adaptive difficulty adjustment

### Economic Risks

#### 1. Market Volatility

**Risk Description:**  
pAI's value is subject to market sentiment, potentially experiencing severe fluctuations.

**Mitigation Measures:**

- Diversified application scenarios
- Stable token economic model
- Long-term value accumulation mechanisms

#### 2. Initial Concentration

**Risk Description:**  
66.67% initial allocation may lead to token concentration, affecting decentralization.

**Mitigation Measures:**

- Transparent allocation plan
- Lockup mechanisms
- Community oversight
- Gradual holder dispersion

#### 3. Rapid Vesting Pool Depletion

**Risk Description:**  
If too many miners are active, the 10M vesting pool may deplete quickly.

**Mitigation Measures:**

- Monitor pool balance
- Community governance decisions
- Economic model adjustments

### Competitive Risks

#### 1. Hash Power Monopoly

**Risk Description:**  
Large hash power miners may monopolize traditional PoW, affecting fairness.

**Mitigation Measures:**

- Dual-track design disperses risk
- Adaptive difficulty adjustment
- Decentralized pool mining

#### 2. Same-Type Project Competition

**Risk Description:**  
Other AI + blockchain projects may divert users and capital.

**Mitigation Measures:**

- Technological innovation advantages
- Early community building
- Application deployment
- Collaboration over competition

### Regulatory Risks

#### 1. Securities Classification

**Risk Description:**  
May be classified as securities, facing regulatory pressure.

**Mitigation Measures:**

- PoW mining mechanism (classified as commodity)
- Decentralized governance
- No ICO/pre-mining
- Legal compliance consultation

#### 2. Energy Consumption Criticism

**Risk Description:**  
PoW mining energy consumption may face criticism.

**Mitigation Measures:**

- Explore green computing solutions
- Emphasize security value
- AI computing integration solutions

---

## Frequently Asked Questions (FAQ)

### Basic Questions

**Q1: Does pAI have its own blockchain?**  
A: No. pAI exists as a smart contract on the Ethereum blockchain. This allows it to leverage a faster, more secure, and modern cryptographic environment while maintaining full compatibility with the Ethereum ecosystem.

**Q2: What is pAI's total supply?**  
A: Total supply is 150,000,000 pAI (150 million), never to be increased.

**Q3: How to obtain pAI?**  
A: Three ways:

1. Participate in traditional PoW mining (instant rewards)
2. Participate in linear vesting mining (delayed rewards)
3. Purchase on DEX (such as Uniswap, SushiSwap)

### Mining-Related

**Q4: What's the difference between traditional PoW and linear vesting mining?**  
A:

- **Traditional PoW**: Instant rewards, intense competition, suitable for professional miners
- **Linear Vesting**: Delayed rewards, moderate competition, suitable for long-term holders
- Can participate in both simultaneously

**Q5: How does pool mining work?**  
A: Essentially the same as classic Bitcoin pool mining, except pAI pools must pay gas to Ethereum. Pools submit solutions on behalf of miners and distribute rewards according to contributions.

**Q6: How often does difficulty adjust?**  
A: Traditional PoW mining adjusts every 2048 epochs. Linear vesting mining's "difficulty" is the same as traditional PoW, but the reward mechanism differs.

**Q7: How is difficulty adjusted?**  
A: Difficulty may increase by maximum 100% or decrease by maximum 50%, targeting approximately 8 minutes (40 Ethereum blocks) per pAI epoch.

**Q8: Are there halving events? When do they occur?**  
A: Yes. Traditional PoW mining halves when reaching specific supply milestones:

- Era 0 → Era 1: 120M tokens
- Era 1 → Era 2: 130M tokens
- Total of 7 halvings

**Q9: How many hash power submissions per day for linear vesting mining?**  
A: Recommend submitting at least 10 valid hash power proofs daily to receive full rewards. Fewer than 10 results in proportionally reduced rewards.

**Q10: How often can linear vesting rewards be claimed?**  
A: Can claim after waiting minimum 1 day. Longer waits accumulate more rewards but require proportionally more hash power submissions.

### Technical Questions

**Q11: What hash algorithm does pAI use?**  
A: Uses dual Keccak256 (SHA3) hashing, similar to Bitcoin's dual SHA256.

**Q12: What hardware is needed for mining?**  
A:

- **Traditional PoW**: GPU mining recommended (e.g., NVIDIA RTX series)
- **Linear Vesting**: CPU mining sufficient (low-frequency submissions)

**Q13: What wallets does pAI support?**  
A: Supports all ERC20-compatible wallets, including:

- Metamask
- Ledger Nano
- Trezor
- Trust Wallet
- imToken
- And any ERC20-supporting wallet

**Q14: How to view mining statistics?**  
A: View in multiple ways:

1. Call the contract's `getMiningStats()` method
2. Use block explorers (such as Etherscan)
3. Use community-developed mining monitoring tools

### Economic Model

**Q15: Why choose 66.67% initial allocation?**  
A: Balances liquidity and decentralization:

- 66.67% ensures project launch liquidity
- 33.33% ensures decentralization through mining
- Carefully designed ratio

**Q16: How is the 100M pAI initial allocation used?**  
A:

- DEX liquidity pools
- AI application incentives
- Community governance reserves
- Strategic partners
- Ecosystem development fund

**Q17: Where does pAI's long-term value come from?**  
A:

1. Payment medium in AI economy
2. Value storage in DeFi ecosystem
3. Scarcity from dual-track mining
4. Rights from decentralized governance
5. Network effects from ecosystem applications

**Q18: Does pAI have lockup mechanisms?**  
A: The smart contract itself has no lockup. All lockup arrangements are decided by and publicly disclosed by initial allocation recipients.

**Q19: How to participate in community governance?**  
A: pAI token holders can:

- Participate in community proposal voting
- Submit improvement suggestions
- Participate in technical discussions
- Contribute code and documentation

**Q20: How is pAI different from other AI tokens?**  
A:

- **Dual-Track Mining**: Unique instant + delayed reward mechanism
- **Fully Decentralized**: No central control
- **PoW Consensus**: True proof of work
- **Ethereum Native**: Deep DeFi ecosystem integration

---

## Disclaimer

This whitepaper is provided for reference only and does not constitute investment advice. Cryptocurrency investment carries high risk and may result in partial or total loss. Before participating:

1. **Conduct Thorough Research**: Understand the project's technology and economic model
2. **Assess Risk**: Evaluate your own risk tolerance
3. **Legal Compliance**: Comply with applicable laws in your jurisdiction
4. **Invest Rationally**: Only invest funds you can afford to lose

The pAI team assumes no responsibility for any investment losses.

---

## Contact Information

- **Official Website**: <https://paitoken.com>
- **GitHub**: <https://github.com/paitokenuu>
- **Email**: <team@paitoken.com>
- **Twitter**: twitter.com/paitoken_uu
- **Telegram**: t.me/paitoken_uu

---

## Copyright Notice

© 2025 pAI Project. All rights reserved.

---

**Last Updated**: January 2025

**Version**: 1.0
