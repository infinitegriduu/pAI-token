# pAI Whitepaper

#### (Whitepaper Revision 1.0)

#### pAI: Decentralized Artificial Intelligence Token — Dual-Track Mining Innovation Model

---

## Abstract

The Ethereum network has proven itself to be the world's first permissionless, transparent, and immutable software application ecosystem. The emergence of smart contracts enables anyone to deploy decentralized applications and achieve interoperability through standard protocols (such as ERC20).

However, traditional ERC20 token distribution methods mostly adopt **ICO/airdrops**, which are easily classified as securities and face centralization risks. In contrast, Bitcoin uses **Proof of Work (PoW) mining** for distribution and is classified as a "commodity".

**pAI** (Proof of AI Token) aims to **combine artificial intelligence with blockchain** to become a **decentralized AI token in the Ethereum ecosystem**. It innovatively adopts a **dual-track mining mechanism**:

- **Traditional PoW Mining (41M pAI, 41%)**: Provides instant rewards, attracting professional miners
- **Linear Release Mining (10M pAI, 10%)**: Incentivizes long-term participation, building a stable community
- **Initial Market Allocation (49M pAI, 49%)**: Ensures liquidity and application implementation

This enables pAI to have both **market driving force** and retain the **security and community-driven nature of decentralized mining**, while achieving fair incentives for long-term holders through an innovative linear release mechanism.

---

## Background

pAI is an ERC20 token written in Solidity 0.8.30, aiming to become a **decentralized AI native asset**.

Unlike traditional tokens that rely on foundations or companies for management, pAI has **no premine, no ICO**, but is governed and distributed through **publicly transparent smart contracts**.

We believe:

- **Artificial Intelligence + Blockchain** is the core combination point of the future
- Decentralized architecture allows global developers and users to share AI economic dividends
- pAI, as an "AI native token", will circulate in multiple scenarios such as **computing power, AI training data, model exchange, and decentralized applications**

### The Importance of Decentralized Tokens

Due to the obvious failure rate of the current ICO market on Ethereum, investors are vulnerable to pseudo-value supported only by speculation. pAI mitigates this problem by providing the Ethereum network with a decentralized Bitcoin-like asset that can serve the role of numerous centralized tokens in a more inviolable and trustless format.

This powerful mechanism frees individuals from using third-party exchanges and third-party custody that are prone to security vulnerabilities and wallet breaches. Moving away from centralization is the core concept of Satoshi Nakamoto's original classic Bitcoin. pAI has the ability to help keep the Ethereum ecosystem open, accountable, trustless, and decentralized at every step of the value transfer process. Unlike Bitcoin, pAI can interact with decentralized exchanges such as Uniswap and SushiSwap because it is fully compatible with Ethereum smart contracts. This means that while Bitcoin can only be traded in a centralized manner, pAI can be traded permissionlessly in immutable permanent smart contracts that cannot be censored or restricted by central entities.

---

## Name Origin

The meaning of "pAI":

- "p" represents **Proof** and **People (community)**
- "AI" represents **Artificial Intelligence**, symbolizing a new generation of intelligence-driven economy

---

## Tokenomics

### Overall Supply Structure

**Total Supply: 100,000,000 pAI (100 million)**

```
Total Supply: 100M pAI
├── Initial Allocation: 49M (49%) - Immediately minted for liquidity and ecosystem building
└── Mineable Supply: 51M (51%) - Community mining release
    ├── Traditional PoW: 41M (80.4% of mineable portion)
    └── Linear Release Pool: 10M (19.6% of mineable portion)
```

### Detailed Distribution

#### 1. Initial Allocation (49M pAI, 49%)

- **Purpose**: Establish liquidity, incentivize early applications, support ecosystem development
- **Release Method**: One-time minting at contract deployment
- **Usage**:
  - Decentralized Exchange (DEX) liquidity pools
  - AI application incentive programs
  - Community governance reserves
  - Strategic partner incentives

#### 2. Traditional PoW Mining (41M pAI, 41%)

- **Purpose**: Decentralized distribution, ensuring token fairness
- **Mechanism**: Proof of Work (Keccak256)
- **Features**: Instant rewards, suitable for professional miners
- **Initial Reward**: 100 pAI/epoch
- **Halving Mechanism**: 7 halvings, expected to last 100 years

**Reward Halving Schedule:**

```
Era 0: 100 pAI   → Target supply: 69.5M (49M + 20.5M)
Era 1: 50 pAI    → Target supply: 79.75M (49M + 30.75M)
Era 2: 25 pAI    → Target supply: 84.875M
Era 3: 12.5 pAI  → Target supply: 87.4375M
Era 4: 6.25 pAI  → Target supply: 88.71875M
Era 5: 3.125 pAI → Target supply: 89.359375M
Era 6: 1.5625 pAI → Target supply: 89.6796875M
Era 7: 0.78125 pAI → Target supply: 90M (final)
```

#### 3. Linear Release Mining (10M pAI, 10%) — Innovative Mechanism 🌟

- **Purpose**: Incentivize long-term participation, build stable community
- **Mechanism**: Hash power accumulation + time release
- **Features**: Delayed rewards, suitable for long-term holders
- **Daily Reward**: 0.5 pAI/day/miner
- **Requirement**: Submit at least 10 valid hash power proofs per day

**Linear Release Workflow:**

```
1. Miner submits hash power proof (submitHashPower)
   ├─ Verify PoW (same difficulty as traditional mining)
   ├─ Accumulate accumulatedHashPower++
   └─ No immediate reward

2. Time accumulation (minimum 1 day)
   └─ daysPassed = (current time - last claim) / 1 day

3. Claim vesting reward (claimVestingReward)
   ├─ baseReward = daysPassed × 0.5 pAI
   ├─ requiredHashPower = daysPassed × 10
   └─ Calculate actual reward:
       if (accumulated >= required)
           actualReward = baseReward (full amount)
       else
           actualReward = baseReward × (accumulated / required)
```

**Hash Power Penalty Mechanism Examples:**

```
Scenario 1: Sufficient Hash Power ✅
- 10 days passed
- Required: 10 × 10 = 100 submissions
- Actual: 120 submissions
- Reward: 10 × 0.5 = 5 pAI (full amount)

Scenario 2: Insufficient Hash Power ⚠️
- 10 days passed
- Required: 10 × 10 = 100 submissions
- Actual: 50 submissions
- Reward: 5 × (50/100) = 2.5 pAI (halved)

Scenario 3: Minimal Hash Power ❌
- 30 days passed
- Required: 30 × 10 = 300 submissions
- Actual: 30 submissions
- Reward: 15 × (30/300) = 1.5 pAI (only 10%)
```

### Economic Model Advantages

This design ensures:

- **Liquidity**: 49% released in advance, can quickly enter DeFi and application ecosystem
- **Fairness**: 51% through hash power competition, avoiding monopolization by a few
- **Long-term**: 10M linear release pool incentivizes continuous participation
- **Stability**: Dual-track system meets different types of miners' needs

---

## Mining Mechanism Details

### Traditional PoW Mining

#### Mining Algorithm

pAI uses double Keccak256 (SHA3) algorithm for mining, similar to Bitcoin's double SHA256:

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

**Parameter Description:**

- **nonce**: Random number chosen by mining software
- **minerAddress**: Miner's Ethereum address, prevents man-in-the-middle attacks and supports pool mining
- **challengeNumber**: Recent Ethereum block hash, updated each round to prevent premining
- **miningTarget**: Difficulty target, automatically decreases as network hash power increases

#### Difficulty Adjustment Mechanism

**Adjustment Period**: Every 2048 epochs
**Target Rate**: 40 Ethereum blocks = 1 pAI epoch (~8 minutes)
**Adjustment Range**: ±50% (maximum change)
**Difficulty Range**: `2^16` (hardest) ~ `2^234` (easiest)

```solidity
// Mining too fast → Increase difficulty
if (ethBlocks < TARGET_BLOCKS_PER_PERIOD) {
    uint256 excessPct = ((TARGET - ethBlocks) * 1000) / TARGET;
    uint256 decrease = (target / 2000) * excessPct;
    miningTarget -= decrease; // Decrease by up to 50%
}

// Mining too slow → Decrease difficulty
else {
    uint256 shortagePct = ((ethBlocks - TARGET) * 1000) / TARGET;
    uint256 increase = (target / 2000) * shortagePct;
    miningTarget += increase; // Increase by up to 50%
}
```

#### Double-Spend Prevention Mechanism

```solidity
// Can only mine once per Ethereum block
if (lastRewardEthBlockNumber == block.number) 
    revert AlreadyMinedInBlock();
```

### Linear Release Mining

#### Core Parameters

```solidity
DAILY_VESTING_REWARD = 0.5 pAI        // Daily base reward
REQUIRED_DAILY_HASH_POWER = 10         // Hash power submissions needed for full reward
VESTING_POOL_ALLOCATION = 10,000,000 pAI  // Total release pool
```

#### Miner State Tracking

```solidity
struct MinerStake {
    uint256 accumulatedHashPower;      // Accumulated hash power count
    uint256 lastClaimTime;              // Last claim time
    uint256 totalVestingClaimed;        // Total vesting rewards claimed
}
```

#### Key Functions

**1. submitHashPower(uint256 nonce, bytes32 challenge_digest)**

- Verify proof of work
- Accumulate miner's hash power count
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

**Actual Scenarios:**

```
- 1,000 active miners: 500 pAI/day
- 10,000 active miners: 5,000 pAI/day
- 100,000 active miners: 50,000 pAI/day
```

### Mining Cost-Benefit Comparison

| Feature | Traditional PoW Mining | Linear Release Mining |
|---------|------------------------|----------------------|
| Reward Time | ⚡ Instant | ⏰ Delayed (minimum 1 day) |
| Target Audience | 👨‍💻 Professional miners | 👥 Long-term holders |
| Competition Level | 🔥 Intense | ❄️ Moderate |
| Hash Power Requirement | 📈 Continuous high hash power | 📊 Low-frequency submission |
| Income Model | 💰 High risk high return | 💵 Stable passive income |
| Gas Cost | 💸 Higher | 💲 Lower |

---

## Account System and Security Features

### ERC20 Standard Compatibility

pAI fully implements the ERC20 standard, compatible with all Ethereum wallets and DeFi protocols:

- Metamask
- Ledger Nano
- Trezor
- Trust Wallet
- Any wallet supporting ERC20

### EIP-2612 Permit Support

pAI implements the EIP-2612 standard, supporting gasless approvals:

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
- Saves one transaction's gas fee
- Improves user experience

### Security Mechanisms

#### 1. Custom Errors (Gas Optimization)

```solidity
error InvalidProofOfWork();        // Invalid proof of work
error AlreadyMinedInBlock();       // Duplicate mining in same block
error MaxSupplyExceeded();         // Maximum supply exceeded
error VestingPoolDepleted();       // Vesting pool depleted
error TooSoonToClaim();            // Too soon to claim
error InsufficientHashPower();     // Insufficient hash power
error ZeroAddress();               // Zero address
error InsufficientBalance();       // Insufficient balance
error InsufficientAllowance();     // Insufficient allowance
error PermitExpired();             // Permit expired
error InvalidSignature();          // Invalid signature
```

#### 2. Reentrancy Protection

Uses "Check-Effects-Interactions" pattern:

```solidity
// ✅ Safe pattern
tokensMinted += reward;          // 1. Update state first
_mint(miner, reward);            // 2. Then mint tokens
challengeNumber = blockhash(block.number - 1);  // 3. Update challenge
```

#### 3. Overflow Protection

Solidity 0.8.30 enables overflow checks by default, using unchecked only in safe places:

```solidity
unchecked {
    // Only use where overflow is impossible
    epochCount++;
    stake.accumulatedHashPower++;
}
```

#### 4. Access Control

```solidity
// Does not accept direct ETH transfers
receive() external payable {
    revert ETHNotAccepted();
}
```

---

## Pool Mining

When mining pAI, miners must pay a small gas fee each time they submit a solution to execute the smart contract's mint() or submitHashPower() function. To reduce the gas fee burden on miners, they can choose to join pool mining.

### Pool Operation Methods

**Traditional PoW Pools:**

- Pool submits solutions on behalf of miners and pays gas fees
- Pool typically takes a small percentage of rewards, the rest goes to miners providing PoW solutions
- Since the miner's Ethereum address is included in the proof of work, miners must mine using the pool's Ethereum address
- Pool accepts "partial solutions", miners get "shares" from the pool for solutions that are close to valid but not fully valid

**Linear Release Pools:**

- Pool can submit hash power proofs on behalf of miners
- Miners' accumulated hash power belongs to their own address
- Miners can independently claim vesting rewards
- Reduces individual miners' gas costs

This mechanism follows the same methodology as Bitcoin and Ethereum proof-of-work pool mining.

---

## Smart Contract Interface

### Core State Variables

```solidity
// ERC20 basics
string public constant name = "Proof of AI";
string public constant symbol = "pAI";
uint8 public constant decimals = 18;
uint256 public totalSupply;

// Supply constants
uint256 public constant MAXIMUM_SUPPLY = 100_000_000 * 10**18;
uint256 public constant INITIAL_ALLOCATION = 49_000_000 * 10**18;
uint256 public constant POW_ALLOCATION = 41_000_000 * 10**18;
uint256 public constant VESTING_POOL_ALLOCATION = 10_000_000 * 10**18;

// Mining parameters
uint256 public constant BLOCKS_PER_READJUSTMENT = 2048;
uint256 public constant MINIMUM_TARGET = 2**16;
uint256 public constant MAXIMUM_TARGET = 2**234;
uint256 public constant TARGET_BLOCKS_PER_PERIOD = 40;

// Linear release parameters
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
// Core mining function
function mint(uint256 nonce, bytes32 challenge_digest) external returns (bool);

// Query methods
function getChallengeNumber() external view returns (bytes32);
function getMiningDifficulty() external view returns (uint256);
function getMiningTarget() external view returns (uint256);
function getMiningReward() external view returns (uint256);

// Debug methods
function getMintDigest(
    uint256 nonce,
    bytes32 challenge_digest,
    bytes32 challenge_number
) external view returns (bytes32);

function checkMintSolution(
    uint256 nonce,
    bytes32 challenge_digest,
    bytes32 challenge_number,
    uint testTarget
) external view returns (bool);
```

### Linear Release Mining Methods

```solidity
// Submit hash power proof
function submitHashPower(uint256 nonce, bytes32 challenge_digest) external;

// Claim vesting reward
function claimVestingReward() external;

// Query methods
function getMinerVestingStats(address miner) external view returns (
    uint256 accumulatedHashPower,
    uint256 pendingReward,
    uint256 daysSinceLastClaim,
    uint256 totalVestingClaimed
);

function calculatePendingVestingReward(address miner) external view returns (uint256);
```

### Statistics Query Methods

```solidity
function getMiningStats() external view returns (
    uint256 currentReward,
    uint256 difficulty,
    uint256 epochCount,
    uint256 tokensMinted,
    uint256 totalVestingClaimed,
    uint256 totalActiveMiners
);
```

### Event Definitions

```solidity
// ERC20 standard events
event Transfer(address indexed from, address indexed to, uint256 value);
event Approval(address indexed owner, address indexed spender, uint256 value);

// Mining events
event Mint(
    address indexed from,
    uint256 reward_amount,
    uint256 epochCount,
    bytes32 newChallengeNumber
);

event DifficultyAdjusted(
    uint256 newDifficulty,
    uint256 newTarget,
    uint256 epochCount
);

event EraTransition(uint256 newEra, uint256 newReward);

// Linear release events
event HashPowerSubmitted(
    address indexed miner,
    uint256 accumulatedHashPower,
    uint256 timestamp
);

event VestingRewardClaimed(
    address indexed miner,
    uint256 reward,
    uint256 daysPassed,
    uint256 hashPowerUsed
);
```

---

## Use Cases

### 1. Payment and Incentives in AI Economy

- **AI Computing Power Market**: Users rent GPU/TPU computing power for AI training using pAI
- **Model Trading Market**: Developers purchase pre-trained AI models with pAI
- **Dataset Trading**: Data providers sell high-quality training data through pAI
- **AI Service Payment**: DApp users pay for AI inference service fees using pAI

### 2. DeFi Ecosystem Integration

- **Collateral Lending**: pAI can be used as collateral in protocols like Aave and Compound
- **Liquidity Mining**: Provide pAI/ETH, pAI/USDC liquidity to earn rewards
- **Yield Aggregators**: Automatically optimize pAI's DeFi yield strategies
- **Derivatives Trading**: Futures, options and other derivatives based on pAI

### 3. Cross-chain and AI Markets

- **Cross-chain Bridge**: Bridge pAI to other chains through LayerZero, Axelar, etc.
- **Multi-chain Deployment**: Deploy on L2s like Polygon, Arbitrum, Optimism
- **Decentralized AI Market**: Establish cross-chain AI model and service market
- **Interoperability**: Achieve interoperability with other AI token projects

### 4. Value Storage in Ethereum Ecosystem

- **Value Storage**: pAI can serve as the primary medium of exchange and value storage for the Ethereum network
- **Network Security**: Allows Ether to focus on its original function - securing the network
- **Ecosystem Position**: As the "Bitcoin" of the Ethereum ecosystem, with all characteristics of Bitcoin
- **Combined Advantages**: Has both the speed and scalability of the Ethereum network

### 5. Community Governance and Incentives

- **Community Proposals**: Holders can participate in governance voting with pAI
- **Contribution Incentives**: Reward developers and users who contribute to the ecosystem
- **Ecosystem Fund**: Establish ecosystem development fund from initial allocation
- **Partner Incentives**: Incentivize AI projects and applications to integrate pAI

---

## Innovation Highlights

### 1. Dual-Track Mining Design 🎯

- **Instant Satisfaction**: Traditional PoW meets professional miners' needs
- **Long-term Incentive**: Linear release incentivizes stable participation
- **Flexible Choice**: Miners can participate in both types of mining
- **Risk Diversification**: Reduces risks of single mining mode

### 2. Hash Power Proof Separation Mechanism 🔄

- **Submission and Reward Separation**: Submitting hash power ≠ immediate reward
- **Time Lock**: Minimum 1-day waiting period
- **Hash Power Accumulation**: Encourages continuous participation
- **Fair Distribution**: Prevents hash power monopoly

### 3. Adaptive Difficulty Adjustment ⚖️

- **Precise Adjustment**: Adjusts every 2048 epochs
- **Target Rate**: Maintains 8-minute block time
- **Range Limit**: ±50% maximum change
- **Network Stability**: Automatically adapts to hash power changes

### 4. Gas Optimization Strategy ⛽

- **Custom Errors**: Saves about 50% gas compared to require + string
- **Unchecked Arithmetic**: Uses in safe places, saves gas
- **Event Optimization**: Streamlines event parameters
- **State Variable Optimization**: Reasonable use of storage and memory

### 5. Security Protection Mechanism 🛡️

- **Reentrancy Protection**: CEI pattern prevents reentrancy attacks
- **Overflow Protection**: Solidity 0.8.30 default overflow checks
- **Double-Spend Prevention**: Can only mine once per block
- **Signature Verification**: EIP-712 standard signature verification

---

## Economic Model In-Depth Analysis

### Inflation Rate Calculation

#### Traditional PoW Part

**Assumptions:**

- 40 ETH blocks = 1 pAI epoch (~8 minutes)
- Daily epochs = 24 × 60 / 8 = 180 epochs

**Daily Production by Era:**

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
Era 0: (18,000 × 365) / 49M = 13.4% (first year)
Era 1: (9,000 × 365) / 69.5M = 4.7%
Era 2: (4,500 × 365) / 79.75M = 2.1%
...
```

#### Linear Release Part

**Maximum Theoretical Output:**

```
Active miners × 0.5 pAI/day
```

**Actual Scenario Analysis:**

```
┌──────────────┬──────────────┬─────────────────┬───────────────┐
│ Active Miners│ Daily Output │ Annual Output   │ Depletion Time│
├──────────────┼──────────────┼─────────────────┼───────────────┤
│ 1,000        │ 500 pAI      │ 182,500 pAI     │ 54.8 years    │
│ 5,000        │ 2,500 pAI    │ 912,500 pAI     │ 11.0 years    │
│ 10,000       │ 5,000 pAI    │ 1,825,000 pAI   │ 5.5 years     │
│ 50,000       │ 25,000 pAI   │ 9,125,000 pAI   │ 1.1 years     │
└──────────────┴──────────────┴─────────────────┴───────────────┘
```

### Mining Revenue Model

#### Traditional PoW Revenue

**Single Miner Daily Revenue:**

```
Daily revenue = (Miner hash power / Total network hash power) × Daily production × Block success rate
```

**Example Calculation:**

```
Assumptions:
- Miner hash power: 100 MH/s
- Total network hash power: 10 GH/s (10,000 MH/s)
- Era 0 daily production: 18,000 pAI
- Block success rate: 95%

Daily revenue = (100 / 10,000) × 18,000 × 0.95 = 171 pAI/day
Monthly revenue = 171 × 30 = 5,130 pAI/month
```

#### Linear Release Revenue

**Full Reward Condition:**

```
Submit ≥ 10 valid hash power proofs per day
```

**Revenue Calculation:**

```
Maximum daily revenue = 0.5 pAI
Maximum monthly revenue = 0.5 × 30 = 15 pAI
Maximum annual revenue = 0.5 × 365 = 182.5 pAI
```

**Hash Power Shortage Penalty:**

```
Actual revenue = Base reward × (Actual hash power submissions / Required hash power submissions)
```

### Total Revenue Comparison

**Professional Miner Strategy:**

- Mainly participate in traditional PoW (high hash power investment)
- Also engage in linear release (low-frequency submission)
- Expected monthly revenue: 5,000+ pAI

**Regular Holder Strategy:**

- Mainly participate in linear release (low-cost participation)
- Occasionally participate in traditional PoW (luck factor)
- Expected monthly revenue: 15-50 pAI

---

## Hash Power Calculation

### Hash Power Units

```
1 KH/s = 1,000 hashes/second
1 MH/s = 1,000,000 hashes/second
1 GH/s = 1,000,000,000 hashes/second
1 TH/s = 1,000,000,000,000 hashes/second
```

### Block Solution Time Calculation

```solidity
Block solution time (seconds) = (Difficulty × 2^22) / Hash power (hashes/second)
```

**Example:**

```
Assumptions:
- Current difficulty: 1,000,000
- Miner hash power: 100 MH/s = 100,000,000 H/s

Solution time = (1,000,000 × 2^22) / 100,000,000
              = (1,000,000 × 4,194,304) / 100,000,000
              = 41,943 seconds
              ≈ 11.65 hours
```

### Success Rate Calculation

```
Success probability per attempt = Current difficulty target / Maximum target value
Attempts per second = Hash power (H/s)
Expected solution time = 1 / (Success probability per attempt × Attempts per second)
```

---

## Roadmap

### Phase 1: Launch Phase (Q4 2025)

- ✅ Smart contract development completed
- ✅ Security audit
- ✅ Testnet deployment
- 🔄 Mainnet deployment
- 🔄 Initial liquidity pool establishment
- 🔄 Miner community formation

### Phase 2: Ecosystem Building (Q1-Q2 2026)

- Mining pool software development
- Block explorer launch
- DEX liquidity incentives
- First batch of AI DApp integration
- Community governance activation

### Phase 3: Application Implementation (Q3-Q4 2026)

- AI computing power market launch
- Model trading market Beta
- Cross-chain bridge deployment
- L2 expansion solutions
- Partner ecosystem expansion

### Phase 4: Ecosystem Prosperity (2027+)

- Full multi-chain deployment
- Mature AI service ecosystem
- Deep DeFi integration
- Improved decentralized governance
- Global community expansion

---

## Risks & Challenges

### Technical Risks

#### 1. Ethereum Network Dependency

**Risk Description:**
High gas fees or network congestion may affect mining efficiency and user experience.

**Mitigation Measures:**

- Optimize contract gas consumption
- Support L2 expansion solutions (Arbitrum, Optimism)
- Develop batch submission functionality

#### 2. Smart Contract Security

**Risk Description:**
Potential contract vulnerabilities may lead to fund loss.

**Mitigation Measures:**

- Multiple security audits
- Bug bounty program
- Time lock mechanism
- Community oversight

#### 3. Transaction Rollback During Difficulty Adjustment

**Risk Description:**
When difficulty is too low relative to hash power, multiple valid solutions may be submitted in a short time, causing transaction rollbacks.

**Mitigation Measures:**

- Double-spend prevention mechanism
- Pool coordination
- Adaptive difficulty adjustment

### Economic Risks

#### 1. Market Volatility

**Risk Description:**
pAI's value is affected by market sentiment and may experience severe volatility.

**Mitigation Measures:**

- Diversified application scenarios
- Stable tokenomics model
- Long-term value accumulation mechanism

#### 2. Initial Concentration

**Risk Description:**
49% initial allocation may lead to token concentration, affecting decentralization.

**Mitigation Measures:**

- Transparent allocation plan
- Lock-up mechanism
- Community oversight
- Gradual dispersion of holdings

#### 3. Rapid Depletion of Release Pool

**Risk Description:**
If there are too many active miners, the 10M release pool may deplete quickly.

**Mitigation Measures:**

- Monitor pool balance
- Dynamically adjust release parameters
- Community governance decisions

### Competition Risks

#### 1. Hash Power Monopoly

**Risk Description:**
Large hash power miners may monopolize traditional PoW, affecting fairness.

**Mitigation Measures:**

- Dual-track system disperses risk
- Adaptive difficulty adjustment
- Decentralized mining pools

#### 2. Competition from Similar Projects

**Risk Description:**
Other AI + blockchain projects may divert users and funds.

**Mitigation Measures:**

- Technical innovation advantages
- Early community building
- Application scenario implementation
- Cooperation over competition

### Regulatory Risks

#### 1. Securities Classification

**Risk Description:**
May be classified as a security, facing regulatory pressure.

**Mitigation Measures:**

- PoW mining mechanism (classified as commodity)
- Decentralized governance
- No ICO/premine
- Legal compliance consultation

#### 2. Energy Consumption Controversy

**Risk Description:**
Energy consumption of PoW mining may be criticized.

**Mitigation Measures:**

- Explore green computing power solutions
- Emphasize security value
- Consider hybrid consensus mechanism in future
- AI computation integration solution

---

## FAQ

### Basic Questions

**Q1: Does pAI have its own blockchain?**
A: No. pAI exists as a smart contract on the Ethereum blockchain. This allows it to leverage a faster, more secure, and modern cryptographic environment while maintaining full compatibility with the Ethereum ecosystem.

**Q2: What is the total supply of pAI?**
A: The total supply is 100,000,000 pAI (100 million), with no additional issuance.

**Q3: How to obtain pAI?**
A: There are three ways:

1. Participate in traditional PoW mining (instant rewards)
2. Participate in linear release mining (delayed rewards)
3. Purchase on DEX (such as Uniswap, SushiSwap)

### Mining Related

**Q4: What is the difference between traditional PoW and linear release mining?**
A:

- **Traditional PoW**: Instant rewards, intense competition, suitable for professional miners
- **Linear Release**: Delayed rewards, moderate competition, suitable for long-term holders
- Can participate in both types of mining simultaneously

**Q5: How does pool mining work?**
A: Essentially the same as classic Bitcoin pool mining, except that pAI pools must pay gas fees to the Ethereum network. Pools submit solutions on behalf of miners and distribute rewards according to contribution.

**Q6: How often is difficulty updated?**
A: Traditional PoW mining updates every 2048 epochs. The "difficulty" of linear release mining is the same as traditional PoW, but the reward mechanism is different.

**Q7: How is difficulty updated?**
A: Difficulty may increase by up to 100% or decrease by 50%, targeting approximately 8 minutes (40 Ethereum blocks) per pAI epoch.

**Q8: Will there be reward halving events? When?**
A: Yes. Traditional PoW mining halves when reaching specific supply stages:

- Era 0 → Era 1: 69.5M tokens
- Era 1 → Era 2: 79.75M tokens
- Total of 7 halvings

**Q9: How many hash power submissions are needed per day for linear release mining?**
A: It is recommended to submit at least 10 valid hash power proofs per day to receive full rewards. Less than 10 submissions will result in proportionally reduced rewards.

**Q10: How often can linear release rewards be claimed?**
A: Can be claimed after waiting at least 1 day. The longer the wait, the more accumulated rewards, but requires submitting more hash power proofs accordingly.

### Technical Questions

**Q11: What hashing algorithm does pAI use?**
A: Uses double Keccak256 (SHA3) algorithm, similar to Bitcoin's double SHA256.

**Q12: What kind of hardware do I need for mining?**
A:

- **Traditional PoW**: Recommended GPU mining (such as NVIDIA RTX series)
- **Linear Release**: CPU mining is sufficient (low-frequency submission)

**Q13: Which wallets does pAI support?**
A: Supports all ERC20-compatible wallets, including:

- Metamask
- Ledger Nano
- Trezor
- Trust Wallet
- imToken
- Any wallet supporting ERC20

**Q14: How to view mining statistics?**
A: Can be viewed through:

1. Calling the contract's `getMiningStats()` method
2. Using block explorers (such as Etherscan)
3. Using community-developed mining monitoring tools

### Economic Model

**Q15: Why choose 49% initial allocation?**
A: To balance liquidity and decentralization:

- 49% ensures liquidity at project launch
- 51% through mining ensures decentralization
- This is a carefully designed golden ratio

**Q16: How will the 49M pAI initial allocation be used?**
A:

- DEX liquidity pools
- AI application incentives
- Community governance reserves
- Strategic partners
- Ecosystem development fund

**Q17: Where does pAI's long-term value come from?**
A:

1. Payment medium for AI economy
2. Value storage in DeFi ecosystem
3. Gas token for decentralized applications
4. Settlement currency for cross-chain AI markets
5. Proof of rights for community governance

### Application Scenarios

**Q18: What can pAI be used for?**
A:

- Purchase AI computing power and models
- DeFi collateral lending
- DEX liquidity mining
- AI service payment
- Community governance voting
- Cross-chain value transfer

**Q19: What makes pAI different from other AI tokens?**
A:

- Innovative dual-track mining mechanism
- True decentralization (no ICO/premine)
- Linear release incentivizes long-term participation
- Fully compatible with Ethereum ecosystem
- Focus on AI economic applications

**Q20: Will pAI be listed on centralized exchanges?**
A: The project focuses on decentralized exchanges (DEX), but does not rule out future listings on compliant centralized exchanges to improve liquidity.

---

## Community & Governance

### Community Structure

**Core Team:**

- Smart contract development
- Security audit
- Ecosystem building
- Community operations

**Community Roles:**

- Miners (traditional PoW + linear release)
- Holders
- Developers
- Application integrators
- Governance participants

### Governance Mechanism

**Proposal Process:**

1. Community members submit proposals
2. Community discussion and improvement
3. Holders vote (weighted by holdings)
4. Execute after reaching threshold

**Governance Scope:**

- Protocol parameter adjustments
- Ecosystem fund usage
- Major upgrade decisions
- Partner selection

### Incentive Mechanism

**Developer Incentives:**

- Ecosystem fund support
- Bug bounty rewards
- Incentives for applications integrating pAI

**Community Incentives:**

- Content creation rewards
- Community promotion incentives
- Governance participation rewards

---

## Technical Documentation Resources

### Development Documentation

- Smart Contract Source Code: [GitHub Repository]
- API Documentation: [Documentation Site]
- Mining Guide: [Mining Guide]
- Integration Tutorial: [Integration Tutorial]

### Community Resources

- Official Website: [Website]
- Discord Community: [Discord Link]
- Telegram Channel: [Telegram Link]
- Twitter: [Twitter Handle]
- Medium Blog: [Medium Link]

### Development Tools

- Miner Software: [Miner Software]
- Block Explorer: [Block Explorer]
- Wallet Integration: [Wallet Integration]
- Statistics Dashboard: [Stats Dashboard]

---

## Conclusion

**pAI is the first innovative dual-track PoW + linear release ERC20 token to introduce the AI concept into blockchain.**

### Core Advantages Summary

1. **Innovative Dual-Track Mining Mechanism** 🎯
   - Traditional PoW: 41M (instant rewards)
   - Linear release: 10M (delayed rewards)
   - Meets different types of participants' needs

2. **True Decentralization** 🌐
   - No ICO/premine
   - 51% distributed through mining
   - Community-driven governance

3. **Complete Economic Model** 💰
   - 100M total supply, never increased
   - Halving mechanism controls inflation
   - Long-term value accumulation

4. **Strong Security Guarantee** 🛡️
   - Multiple security mechanisms
   - Audited code
   - Community oversight

5. **Rich Application Scenarios** 🚀
   - AI economic payment
   - DeFi ecosystem integration
   - Cross-chain interoperability
   - Value storage

### Comparison with Bitcoin and Ethereum

pAI combines the advantages of Bitcoin and Ethereum:

**Inherits from Bitcoin:**

- ✅ Decentralization
- ✅ Permissionless
- ✅ Mineable
- ✅ Scarcity

**Surpasses Bitcoin:**

- ✅ Ethereum's speed
- ✅ Smart contract compatibility
- ✅ DeFi ecosystem integration
- ✅ No need for centralized exchanges

### Vision

As the "AI-driven Bitcoin" of the Ethereum ecosystem, pAI is committed to:

- Becoming the **core token of the global AI economy**
- Promoting the development of **decentralized AI applications**
- Establishing a **fair, transparent, and efficient** AI value network
- Achieving **deep integration of artificial intelligence and blockchain**

In the future, all Ethereum smart contracts can permissionlessly hold, transfer, and trade pAI, and can be implemented according to immutable rules set by their own computer code. pAI will become a bridge connecting the AI world and the blockchain world, promoting the common prosperity of both fields.

---

## Disclaimer

This whitepaper is for reference only and does not constitute any investment advice. pAI tokens are utility tokens, not securities. Participating in mining and holding pAI involves risks, please assess for yourself.

**Important Notes:**

- Cryptocurrency investment carries high risks
- Do not invest more than you can afford to lose
- Please conduct your own due diligence
- Comply with local laws and regulations

---

## References

1. Satoshi Nakamoto. Bitcoin: A Peer-to-Peer Electronic Cash System, 2009.
   <http://www.bitcoin.org/bitcoin.pdf>

2. Vitalik Buterin. Ethereum White Paper, 2014.
   <https://github.com/ethereum/wiki/wiki/White-Paper>

3. Fabian Vogelsteller and Vitalik Buterin. ERC-20 Token Standard, 2015.
   <https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md>

4. Logelin J and 0xBitcoin community members. ERC 541 - Mineable Token Standard Draft, 2018.
   <https://github.com/ethereum/EIPs/pull/918>

5. EIP-2612: Permit Extension for EIP-20 Signed Approvals, 2020.
   <https://eips.ethereum.org/EIPS/eip-2612>

6. Solidity Documentation, Version 0.8.30, 2024.
   <https://docs.soliditylang.org/>

---

## Whitepaper Version History

- **v1.0** (Oct 2025): Initial version release

---

## Whitepaper Contributors

**Core Team:**

- pAI Smart Contract Development Team
- Technical Documentation Writing Team
- Security Audit Team
- Community Operations Team

**Special Thanks:**

- Ethereum Community
- 0xBitcoin Community
- All early supporters and contributors

**Contact:**

- Email: <team@paitoken.com>
- GitHub: github.com/infinitegriduu
- Discord: discord.gg/paitoken_uu

---

*Last updated: October 2025*
