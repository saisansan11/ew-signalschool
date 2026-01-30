---
name: concise-planning
description: Use when a user asks for a plan for a coding task, to generate a clear, actionable, and atomic checklist.
---

# Concise Planning

## Goal

Turn a user request into a **single, actionable plan** with atomic steps.

## Workflow

### 1. Scan Context

- Read `README.md`, docs, and relevant code files.
- Identify constraints (language, frameworks, tests).

### 2. Minimal Interaction

- Ask **at most 1–2 questions** and only if truly blocking.
- Make reasonable assumptions for non-blocking unknowns.

### 3. Generate Plan

Use the following structure:

- **Approach**: 1-3 sentences on what and why.
- **Scope**: Bullet points for "In" and "Out".
- **Action Items**: A list of 6-10 atomic, ordered tasks (Verb-first).
- **Validation**: At least one item for testing.

## Plan Template

```markdown
# Plan

<High-level approach>

## Scope

- In:
- Out:

## Action Items

[ ] <Step 1: Discovery>
[ ] <Step 2: Implementation>
[ ] <Step 3: Implementation>
[ ] <Step 4: Validation/Testing>
[ ] <Step 5: Rollout/Commit>

## Open Questions

- <Question 1 (max 3)>
```

## Checklist Guidelines

- **Atomic**: Each step should be a single logical unit of work.
- **Verb-first**: "Add...", "Refactor...", "Verify...".
- **Concrete**: Name specific files or modules when possible.

---
name: lint-and-validate
description: "Automatic quality control, linting, and static analysis procedures. Use after every code modification to ensure syntax correctness and project standards. Triggers onKeywords: lint, format, check, validate, types, static analysis."
allowed-tools: Read, Glob, Grep, Bash
---

# Lint and Validate Skill

> **MANDATORY:** Run appropriate validation tools after EVERY code change. Do not finish a task until the code is error-free.

### Procedures by Ecosystem

#### Node.js / TypeScript
1. **Lint/Fix:** `npm run lint` or `npx eslint "path" --fix`
2. **Types:** `npx tsc --noEmit`
3. **Security:** `npm audit --audit-level=high`

#### Python
1. **Linter (Ruff):** `ruff check "path" --fix` (Fast & Modern)
2. **Security (Bandit):** `bandit -r "path" -ll`
3. **Types (MyPy):** `mypy "path"`

## The Quality Loop
1. **Write/Edit Code**
2. **Run Audit:** `npm run lint && npx tsc --noEmit`
3. **Analyze Report:** Check the "FINAL AUDIT REPORT" section.
4. **Fix & Repeat:** Submitting code with "FINAL AUDIT" failures is NOT allowed.

## Error Handling
- If `lint` fails: Fix the style or syntax issues immediately.
- If `tsc` fails: Correct type mismatches before proceeding.
- If no tool is configured: Check the project root for `.eslintrc`, `tsconfig.json`, `pyproject.toml` and suggest creating one.

---
**Strict Rule:** No code should be committed or reported as "done" without passing these checks.

---

## Scripts

| Script | Purpose | Command |
|--------|---------|---------|
| `scripts/lint_runner.py` | Unified lint check | `python scripts/lint_runner.py <project_path>` |
| `scripts/type_coverage.py` | Type coverage analysis | `python scripts/type_coverage.py <project_path>` |


---
name: git-pushing
description: Stage, commit, and push git changes with conventional commit messages. Use when user wants to commit and push changes, mentions pushing to remote, or asks to save and push their work. Also activates when user says "push changes", "commit and push", "push this", "push to github", or similar git workflow requests.
---

# Git Push Workflow

Stage all changes, create a conventional commit, and push to the remote branch.

## When to Use

Automatically activate when the user:

- Explicitly asks to push changes ("push this", "commit and push")
- Mentions saving work to remote ("save to github", "push to remote")
- Completes a feature and wants to share it
- Says phrases like "let's push this up" or "commit these changes"

## Workflow

**ALWAYS use the script** - do NOT use manual git commands:

```bash
bash skills/git-pushing/scripts/smart_commit.sh
```

With custom message:

```bash
bash skills/git-pushing/scripts/smart_commit.sh "feat: add feature"
```

Script handles: staging, conventional commit message, Claude footer, push with -u flag.

---
name: kaizen
description: Guide for continuous improvement, error proofing, and standardization. Use this skill when the user wants to improve code quality, refactor, or discuss process improvements.
---

# Kaizen: Continuous Improvement

## Overview

Small improvements, continuously. Error-proof by design. Follow what works. Build only what's needed.

**Core principle:** Many small improvements beat one big change. Prevent errors at design time, not with fixes.

## When to Use

**Always applied for:**

- Code implementation and refactoring
- Architecture and design decisions
- Process and workflow improvements
- Error handling and validation

**Philosophy:** Quality through incremental progress and prevention, not perfection through massive effort.

## The Four Pillars

### 1. Continuous Improvement (Kaizen)

Small, frequent improvements compound into major gains.

#### Principles

**Incremental over revolutionary:**

- Make smallest viable change that improves quality
- One improvement at a time
- Verify each change before next
- Build momentum through small wins

**Always leave code better:**

- Fix small issues as you encounter them
- Refactor while you work (within scope)
- Update outdated comments
- Remove dead code when you see it

**Iterative refinement:**

- First version: make it work
- Second pass: make it clear
- Third pass: make it efficient
- Don't try all three at once

<Good>
```typescript
// Iteration 1: Make it work
const calculateTotal = (items: Item[]) => {
  let total = 0;
  for (let i = 0; i < items.length; i++) {
    total += items[i].price * items[i].quantity;
  }
  return total;
};

// Iteration 2: Make it clear (refactor)
const calculateTotal = (items: Item[]): number => {
return items.reduce((total, item) => {
return total + (item.price \* item.quantity);
}, 0);
};

// Iteration 3: Make it robust (add validation)
const calculateTotal = (items: Item[]): number => {
if (!items?.length) return 0;

return items.reduce((total, item) => {
if (item.price < 0 || item.quantity < 0) {
throw new Error('Price and quantity must be non-negative');
}
return total + (item.price \* item.quantity);
}, 0);
};

````
Each step is complete, tested, and working
</Good>

<Bad>
```typescript
// Trying to do everything at once
const calculateTotal = (items: Item[]): number => {
  // Validate, optimize, add features, handle edge cases all together
  if (!items?.length) return 0;
  const validItems = items.filter(item => {
    if (item.price < 0) throw new Error('Negative price');
    if (item.quantity < 0) throw new Error('Negative quantity');
    return item.quantity > 0; // Also filtering zero quantities
  });
  // Plus caching, plus logging, plus currency conversion...
  return validItems.reduce(...); // Too many concerns at once
};
````

Overwhelming, error-prone, hard to verify
</Bad>

#### In Practice

**When implementing features:**

1. Start with simplest version that works
2. Add one improvement (error handling, validation, etc.)
3. Test and verify
4. Repeat if time permits
5. Don't try to make it perfect immediately

**When refactoring:**

- Fix one smell at a time
- Commit after each improvement
- Keep tests passing throughout
- Stop when "good enough" (diminishing returns)

**When reviewing code:**

- Suggest incremental improvements (not rewrites)
- Prioritize: critical → important → nice-to-have
- Focus on highest-impact changes first
- Accept "better than before" even if not perfect

### 2. Poka-Yoke (Error Proofing)

Design systems that prevent errors at compile/design time, not runtime.

#### Principles

**Make errors impossible:**

- Type system catches mistakes
- Compiler enforces contracts
- Invalid states unrepresentable
- Errors caught early (left of production)

**Design for safety:**

- Fail fast and loudly
- Provide helpful error messages
- Make correct path obvious
- Make incorrect path difficult

**Defense in layers:**

1. Type system (compile time)
2. Validation (runtime, early)
3. Guards (preconditions)
4. Error boundaries (graceful degradation)

#### Type System Error Proofing

<Good>
```typescript
// Error: string status can be any value
type OrderBad = {
  status: string; // Can be "pending", "PENDING", "pnding", anything!
  total: number;
};

// Good: Only valid states possible
type OrderStatus = 'pending' | 'processing' | 'shipped' | 'delivered';
type Order = {
status: OrderStatus;
total: number;
};

// Better: States with associated data
type Order =
| { status: 'pending'; createdAt: Date }
| { status: 'processing'; startedAt: Date; estimatedCompletion: Date }
| { status: 'shipped'; trackingNumber: string; shippedAt: Date }
| { status: 'delivered'; deliveredAt: Date; signature: string };

// Now impossible to have shipped without trackingNumber

````
Type system prevents entire classes of errors
</Good>

<Good>
```typescript
// Make invalid states unrepresentable
type NonEmptyArray<T> = [T, ...T[]];

const firstItem = <T>(items: NonEmptyArray<T>): T => {
  return items[0]; // Always safe, never undefined!
};

// Caller must prove array is non-empty
const items: number[] = [1, 2, 3];
if (items.length > 0) {
  firstItem(items as NonEmptyArray<number>); // Safe
}
````

Function signature guarantees safety
</Good>

#### Validation Error Proofing

<Good>
```typescript
// Error: Validation after use
const processPayment = (amount: number) => {
  const fee = amount * 0.03; // Used before validation!
  if (amount <= 0) throw new Error('Invalid amount');
  // ...
};

// Good: Validate immediately
const processPayment = (amount: number) => {
if (amount <= 0) {
throw new Error('Payment amount must be positive');
}
if (amount > 10000) {
throw new Error('Payment exceeds maximum allowed');
}

const fee = amount \* 0.03;
// ... now safe to use
};

// Better: Validation at boundary with branded type
type PositiveNumber = number & { readonly \_\_brand: 'PositiveNumber' };

const validatePositive = (n: number): PositiveNumber => {
if (n <= 0) throw new Error('Must be positive');
return n as PositiveNumber;
};

const processPayment = (amount: PositiveNumber) => {
// amount is guaranteed positive, no need to check
const fee = amount \* 0.03;
};

// Validate at system boundary
const handlePaymentRequest = (req: Request) => {
const amount = validatePositive(req.body.amount); // Validate once
processPayment(amount); // Use everywhere safely
};

````
Validate once at boundary, safe everywhere else
</Good>

#### Guards and Preconditions

<Good>
```typescript
// Early returns prevent deeply nested code
const processUser = (user: User | null) => {
  if (!user) {
    logger.error('User not found');
    return;
  }

  if (!user.email) {
    logger.error('User email missing');
    return;
  }

  if (!user.isActive) {
    logger.info('User inactive, skipping');
    return;
  }

  // Main logic here, guaranteed user is valid and active
  sendEmail(user.email, 'Welcome!');
};
````

Guards make assumptions explicit and enforced
</Good>

#### Configuration Error Proofing

<Good>
```typescript
// Error: Optional config with unsafe defaults
type ConfigBad = {
  apiKey?: string;
  timeout?: number;
};

const client = new APIClient({ timeout: 5000 }); // apiKey missing!

// Good: Required config, fails early
type Config = {
apiKey: string;
timeout: number;
};

const loadConfig = (): Config => {
const apiKey = process.env.API_KEY;
if (!apiKey) {
throw new Error('API_KEY environment variable required');
}

return {
apiKey,
timeout: 5000,
};
};

// App fails at startup if config invalid, not during request
const config = loadConfig();
const client = new APIClient(config);

````
Fail at startup, not in production
</Good>

#### In Practice

**When designing APIs:**
- Use types to constrain inputs
- Make invalid states unrepresentable
- Return Result<T, E> instead of throwing
- Document preconditions in types

**When handling errors:**
- Validate at system boundaries

- Use guards for preconditions
- Fail fast with clear messages
- Log context for debugging

**When configuring:**
- Required over optional with defaults
- Validate all config at startup
- Fail deployment if config invalid
- Don't allow partial configurations

### 3. Standardized Work
Follow established patterns. Document what works. Make good practices easy to follow.

#### Principles

**Consistency over cleverness:**
- Follow existing codebase patterns
- Don't reinvent solved problems
- New pattern only if significantly better
- Team agreement on new patterns

**Documentation lives with code:**
- README for setup and architecture
- CLAUDE.md for AI coding conventions
- Comments for "why", not "what"
- Examples for complex patterns

**Automate standards:**
- Linters enforce style
- Type checks enforce contracts
- Tests verify behavior
- CI/CD enforces quality gates

#### Following Patterns

<Good>
```typescript
// Existing codebase pattern for API clients
class UserAPIClient {
  async getUser(id: string): Promise<User> {
    return this.fetch(`/users/${id}`);
  }
}

// New code follows the same pattern
class OrderAPIClient {
  async getOrder(id: string): Promise<Order> {
    return this.fetch(`/orders/${id}`);
  }
}
````

Consistency makes codebase predictable
</Good>

<Bad>
```typescript
// Existing pattern uses classes
class UserAPIClient { /* ... */ }

// New code introduces different pattern without discussion
const getOrder = async (id: string): Promise<Order> => {
// Breaking consistency "because I prefer functions"
};

````
Inconsistency creates confusion
</Bad>

#### Error Handling Patterns

<Good>
```typescript
// Project standard: Result type for recoverable errors
type Result<T, E> = { ok: true; value: T } | { ok: false; error: E };

// All services follow this pattern
const fetchUser = async (id: string): Promise<Result<User, Error>> => {
  try {
    const user = await db.users.findById(id);
    if (!user) {
      return { ok: false, error: new Error('User not found') };
    }
    return { ok: true, value: user };
  } catch (err) {
    return { ok: false, error: err as Error };
  }
};

// Callers use consistent pattern
const result = await fetchUser('123');
if (!result.ok) {
  logger.error('Failed to fetch user', result.error);
  return;
}
const user = result.value; // Type-safe!
````

Standard pattern across codebase
</Good>

#### Documentation Standards

<Good>
```typescript
/**
 * Retries an async operation with exponential backoff.
 *
 * Why: Network requests fail temporarily; retrying improves reliability
 * When to use: External API calls, database operations
 * When not to use: User input validation, internal function calls
 *
 * @example
 * const result = await retry(
 *   () => fetch('https://api.example.com/data'),
 *   { maxAttempts: 3, baseDelay: 1000 }
 * );
 */
const retry = async <T>(
  operation: () => Promise<T>,
  options: RetryOptions
): Promise<T> => {
  // Implementation...
};
```
Documents why, when, and how
</Good>

#### In Practice

**Before adding new patterns:**

- Search codebase for similar problems solved
- Check CLAUDE.md for project conventions
- Discuss with team if breaking from pattern
- Update docs when introducing new pattern

**When writing code:**

- Match existing file structure
- Use same naming conventions
- Follow same error handling approach
- Import from same locations

**When reviewing:**

- Check consistency with existing code
- Point to examples in codebase
- Suggest aligning with standards
- Update CLAUDE.md if new standard emerges

### 4. Just-In-Time (JIT)

Build what's needed now. No more, no less. Avoid premature optimization and over-engineering.

#### Principles

**YAGNI (You Aren't Gonna Need It):**

- Implement only current requirements
- No "just in case" features
- No "we might need this later" code
- Delete speculation

**Simplest thing that works:**

- Start with straightforward solution
- Add complexity only when needed
- Refactor when requirements change
- Don't anticipate future needs

**Optimize when measured:**

- No premature optimization
- Profile before optimizing
- Measure impact of changes
- Accept "good enough" performance

#### YAGNI in Action

<Good>
```typescript
// Current requirement: Log errors to console
const logError = (error: Error) => {
  console.error(error.message);
};
```
Simple, meets current need
</Good>

<Bad>
```typescript
// Over-engineered for "future needs"
interface LogTransport {
  write(level: LogLevel, message: string, meta?: LogMetadata): Promise<void>;
}

class ConsoleTransport implements LogTransport { /_... _/ }
class FileTransport implements LogTransport { /_ ... _/ }
class RemoteTransport implements LogTransport { /_ ..._/ }

class Logger {
private transports: LogTransport[] = [];
private queue: LogEntry[] = [];
private rateLimiter: RateLimiter;
private formatter: LogFormatter;

// 200 lines of code for "maybe we'll need it"
}

const logError = (error: Error) => {
Logger.getInstance().log('error', error.message);
};

````
Building for imaginary future requirements
</Bad>

**When to add complexity:**
- Current requirement demands it
- Pain points identified through use
- Measured performance issues
- Multiple use cases emerged

<Good>
```typescript
// Start simple
const formatCurrency = (amount: number): string => {
  return `$${amount.toFixed(2)}`;
};

// Requirement evolves: support multiple currencies
const formatCurrency = (amount: number, currency: string): string => {
  const symbols = { USD: '$', EUR: '€', GBP: '£' };
  return `${symbols[currency]}${amount.toFixed(2)}`;
};

// Requirement evolves: support localization
const formatCurrency = (amount: number, locale: string): string => {
  return new Intl.NumberFormat(locale, {\n    style: 'currency',
    currency: locale === 'en-US' ? 'USD' : 'EUR',
  }).format(amount);
};
````

Complexity added only when needed
</Good>

#### Premature Abstraction

<Bad>
```typescript
// One use case, but building generic framework
abstract class BaseCRUDService<T> {
  abstract getAll(): Promise<T[]>;
  abstract getById(id: string): Promise<T>;
  abstract create(data: Partial<T>): Promise<T>;
  abstract update(id: string, data: Partial<T>): Promise<T>;
  abstract delete(id: string): Promise<void>;
}

class GenericRepository<T> { /_300 lines _/ }
class QueryBuilder<T> { /_ 200 lines_/ }
// ... building entire ORM for single table

````
Massive abstraction for uncertain future
</Bad>

<Good>
```typescript
// Simple functions for current needs
const getUsers = async (): Promise<User[]> => {
  return db.query('SELECT * FROM users');
};

const getUserById = async (id: string): Promise<User | null> => {
  return db.query('SELECT * FROM users WHERE id = $1', [id]);
};

// When pattern emerges across multiple entities, then abstract
````

Abstract only when pattern proven across 3+ cases
</Good>

#### Performance Optimization

<Good>
```typescript
// Current: Simple approach
const filterActiveUsers = (users: User[]): User[] => {
  return users.filter(user => user.isActive);
};

// Benchmark shows: 50ms for 1000 users (acceptable)
// ✓ Ship it, no optimization needed

// Later: After profiling shows this is bottleneck
// Then optimize with indexed lookup or caching

````
Optimize based on measurement, not assumptions
</Good>

<Bad>
```typescript
// Premature optimization
const filterActiveUsers = (users: User[]): User[] => {
  // "This might be slow, so let's cache and index"
  const cache = new WeakMap();
  const indexed = buildBTreeIndex(users, 'isActive');
  // 100 lines of optimization code
  // Adds complexity, harder to maintain
  // No evidence it was needed
};\
````

Complex solution for unmeasured problem
</Bad>

#### In Practice

**When implementing:**

- Solve the immediate problem
- Use straightforward approach
- Resist "what if" thinking
- Delete speculative code

**When optimizing:**

- Profile first, optimize second
- Measure before and after
- Document why optimization needed
- Keep simple version in tests

**When abstracting:**

- Wait for 3+ similar cases (Rule of Three)
- Make abstraction as simple as possible
- Prefer duplication over wrong abstraction
- Refactor when pattern clear

## Integration with Commands

The Kaizen skill guides how you work. The commands provide structured analysis:

- **`/why`**: Root cause analysis (5 Whys)
- **`/cause-and-effect`**: Multi-factor analysis (Fishbone)
- **`/plan-do-check-act`**: Iterative improvement cycles
- **`/analyse-problem`**: Comprehensive documentation (A3)
- **`/analyse`**: Smart method selection (Gemba/VSM/Muda)

Use commands for structured problem-solving. Apply skill for day-to-day development.

## Red Flags

**Violating Continuous Improvement:**

- "I'll refactor it later" (never happens)
- Leaving code worse than you found it
- Big bang rewrites instead of incremental

**Violating Poka-Yoke:**

- "Users should just be careful"
- Validation after use instead of before
- Optional config with no validation

**Violating Standardized Work:**

- "I prefer to do it my way"
- Not checking existing patterns
- Ignoring project conventions

**Violating Just-In-Time:**

- "We might need this someday"
- Building frameworks before using them
- Optimizing without measuring

## Remember

**Kaizen is about:**

- Small improvements continuously
- Preventing errors by design
- Following proven patterns
- Building only what's needed

**Not about:**

- Perfection on first try
- Massive refactoring projects
- Clever abstractions
- Premature optimization

**Mindset:** Good enough today, better tomorrow. Repeat.

---
name: frontend-design
description: Create distinctive, production-grade frontend interfaces with intentional aesthetics, high craft, and non-generic visual identity. Use when building or styling web UIs, components, pages, dashboards, or frontend applications.
license: Complete terms in LICENSE.txt
---

# Frontend Design (Distinctive, Production-Grade)

You are a **frontend designer-engineer**, not a layout generator.

Your goal is to create **memorable, high-craft interfaces** that:

* Avoid generic “AI UI” patterns
* Express a clear aesthetic point of view
* Are fully functional and production-ready
* Translate design intent directly into code

This skill prioritizes **intentional design systems**, not default frameworks.

---

## 1. Core Design Mandate

Every output must satisfy **all four**:

1. **Intentional Aesthetic Direction**
   A named, explicit design stance (e.g. *editorial brutalism*, *luxury minimal*, *retro-futurist*, *industrial utilitarian*).

2. **Technical Correctness**
   Real, working HTML/CSS/JS or framework code — not mockups.

3. **Visual Memorability**
   At least one element the user will remember 24 hours later.

4. **Cohesive Restraint**
   No random decoration. Every flourish must serve the aesthetic thesis.

❌ No default layouts
❌ No design-by-components
❌ No “safe” palettes or fonts
✅ Strong opinions, well executed

---

## 2. Design Feasibility & Impact Index (DFII)

Before building, evaluate the design direction using DFII.

### DFII Dimensions (1–5)

| Dimension                      | Question                                                     |
| ------------------------------ | ------------------------------------------------------------ |
| **Aesthetic Impact**           | How visually distinctive and memorable is this direction?    |
| **Context Fit**                | Does this aesthetic suit the product, audience, and purpose? |
| **Implementation Feasibility** | Can this be built cleanly with available tech?               |
| **Performance Safety**         | Will it remain fast and accessible?                          |
| **Consistency Risk**           | Can this be maintained across screens/components?            |

### Scoring Formula

```
DFII = (Impact + Fit + Feasibility + Performance) − Consistency Risk
```

**Range:** `-5 → +15`

### Interpretation

| DFII      | Meaning   | Action                      |
| --------- | --------- | --------------------------- |
| **12–15** | Excellent | Execute fully               |
| **8–11**  | Strong    | Proceed with discipline     |
| **4–7**   | Risky     | Reduce scope or effects     |
| **≤ 3**   | Weak      | Rethink aesthetic direction |

---

## 3. Mandatory Design Thinking Phase

Before writing code, explicitly define:

### 1. Purpose

* What action should this interface enable?
* Is it persuasive, functional, exploratory, or expressive?

### 2. Tone (Choose One Dominant Direction)

Examples (non-exhaustive):

* Brutalist / Raw
* Editorial / Magazine
* Luxury / Refined
* Retro-futuristic
* Industrial / Utilitarian
* Organic / Natural
* Playful / Toy-like
* Maximalist / Chaotic
* Minimalist / Severe

⚠️ Do not blend more than **two**.

### 3. Differentiation Anchor

Answer:

> “If this were screenshotted with the logo removed, how would someone recognize it?”

This anchor must be visible in the final UI.

---

## 4. Aesthetic Execution Rules (Non-Negotiable)

### Typography

* Avoid system fonts and AI-defaults (Inter, Roboto, Arial, etc.)
* Choose:

  * 1 expressive display font
  * 1 restrained body font
* Use typography structurally (scale, rhythm, contrast)

### Color & Theme

* Commit to a **dominant color story**
* Use CSS variables exclusively
* Prefer:

  * One dominant tone
  * One accent
  * One neutral system
* Avoid evenly-balanced palettes

### Spatial Composition

* Break the grid intentionally
* Use:

  * Asymmetry
  * Overlap
  * Negative space OR controlled density
* White space is a design element, not absence

### Motion

* Motion must be:

  * Purposeful
  * Sparse
  * High-impact
* Prefer:

  * One strong entrance sequence
  * A few meaningful hover states
* Avoid decorative micro-motion spam

### Texture & Depth

Use when appropriate:

* Noise / grain overlays
* Gradient meshes
* Layered translucency
* Custom borders or dividers
* Shadows with narrative intent (not defaults)

---

## 5. Implementation Standards

### Code Requirements

* Clean, readable, and modular
* No dead styles
* No unused animations
* Semantic HTML
* Accessible by default (contrast, focus, keyboard)

### Framework Guidance

* **HTML/CSS**: Prefer native features, modern CSS
* **React**: Functional components, composable styles
* **Animation**:

  * CSS-first
  * Framer Motion only when justified

### Complexity Matching

* Maximalist design → complex code (animations, layers)
* Minimalist design → extremely precise spacing & type

Mismatch = failure.

---

## 6. Required Output Structure

When generating frontend work:

### 1. Design Direction Summary

* Aesthetic name
* DFII score
* Key inspiration (conceptual, not visual plagiarism)

### 2. Design System Snapshot

* Fonts (with rationale)
* Color variables
* Spacing rhythm
* Motion philosophy

### 3. Implementation

* Full working code
* Comments only where intent isn’t obvious

### 4. Differentiation Callout

Explicitly state:

> “This avoids generic UI by doing X instead of Y.”

---

## 7. Anti-Patterns (Immediate Failure)

❌ Inter/Roboto/system fonts
❌ Purple-on-white SaaS gradients
❌ Default Tailwind/ShadCN layouts
❌ Symmetrical, predictable sections
❌ Overused AI design tropes
❌ Decoration without intent

If the design could be mistaken for a template → restart.

---

## 8. Integration With Other Skills

* **page-cro** → Layout hierarchy & conversion flow
* **copywriting** → Typography & message rhythm
* **marketing-psychology** → Visual persuasion & bias alignment
* **branding** → Visual identity consistency
* **ab-test-setup** → Variant-safe design systems

---

## 9. Operator Checklist

Before finalizing output:

* [ ] Clear aesthetic direction stated
* [ ] DFII ≥ 8
* [ ] One memorable design anchor
* [ ] No generic fonts/colors/layouts
* [ ] Code matches design ambition
* [ ] Accessible and performant

---

## 10. Questions to Ask (If Needed)

1. Who is this for, emotionally?
2. Should this feel trustworthy, exciting, calm, or provocative?
3. Is memorability or clarity more important?
4. Will this scale to other pages/components?
5. What should users *feel* in the first 3 seconds?

---

---
name: react-patterns
description: Modern React patterns and principles. Hooks, composition, performance, TypeScript best practices.
allowed-tools: Read, Write, Edit, Glob, Grep
---

# React Patterns

> Principles for building production-ready React applications.

---

## 1. Component Design Principles

### Component Types

| Type | Use | State |
|------|-----|-------|
| **Server** | Data fetching, static | None |
| **Client** | Interactivity | useState, effects |
| **Presentational** | UI display | Props only |
| **Container** | Logic/state | Heavy state |

### Design Rules

- One responsibility per component
- Props down, events up
- Composition over inheritance
- Prefer small, focused components

---

## 2. Hook Patterns

### When to Extract Hooks

| Pattern | Extract When |
|---------|-------------|
| **useLocalStorage** | Same storage logic needed |
| **useDebounce** | Multiple debounced values |
| **useFetch** | Repeated fetch patterns |
| **useForm** | Complex form state |

### Hook Rules

- Hooks at top level only
- Same order every render
- Custom hooks start with "use"
- Clean up effects on unmount

---

## 3. State Management Selection

| Complexity | Solution |
|------------|----------|
| Simple | useState, useReducer |
| Shared local | Context |
| Server state | React Query, SWR |
| Complex global | Zustand, Redux Toolkit |

### State Placement

| Scope | Where |
|-------|-------|
| Single component | useState |
| Parent-child | Lift state up |
| Subtree | Context |
| App-wide | Global store |

---

## 4. React 19 Patterns

### New Hooks

| Hook | Purpose |
|------|---------|
| **useActionState** | Form submission state |
| **useOptimistic** | Optimistic UI updates |
| **use** | Read resources in render |

### Compiler Benefits

- Automatic memoization
- Less manual useMemo/useCallback
- Focus on pure components

---

## 5. Composition Patterns

### Compound Components

- Parent provides context
- Children consume context
- Flexible slot-based composition
- Example: Tabs, Accordion, Dropdown

### Render Props vs Hooks

| Use Case | Prefer |
|----------|--------|
| Reusable logic | Custom hook |
| Render flexibility | Render props |
| Cross-cutting | Higher-order component |

---

## 6. Performance Principles

### When to Optimize

| Signal | Action |
|--------|--------|
| Slow renders | Profile first |
| Large lists | Virtualize |
| Expensive calc | useMemo |
| Stable callbacks | useCallback |

### Optimization Order

1. Check if actually slow
2. Profile with DevTools
3. Identify bottleneck
4. Apply targeted fix

---

## 7. Error Handling

### Error Boundary Usage

| Scope | Placement |
|-------|-----------|
| App-wide | Root level |
| Feature | Route/feature level |
| Component | Around risky component |

### Error Recovery

- Show fallback UI
- Log error
- Offer retry option
- Preserve user data

---

## 8. TypeScript Patterns

### Props Typing

| Pattern | Use |
|---------|-----|
| Interface | Component props |
| Type | Unions, complex |
| Generic | Reusable components |

### Common Types

| Need | Type |
|------|------|
| Children | ReactNode |
| Event handler | MouseEventHandler |
| Ref | RefObject<Element> |

---

## 9. Testing Principles

| Level | Focus |
|-------|-------|
| Unit | Pure functions, hooks |
| Integration | Component behavior |
| E2E | User flows |

### Test Priorities

- User-visible behavior
- Edge cases
- Error states
- Accessibility

---

## 10. Anti-Patterns

| ❌ Don't | ✅ Do |
|----------|-------|
| Prop drilling deep | Use context |
| Giant components | Split smaller |
| useEffect for everything | Server components |
| Premature optimization | Profile first |
| Index as key | Stable unique ID |

---

> **Remember:** React is about composition. Build small, combine thoughtfully.

---
name: tailwind-patterns
description: Tailwind CSS v4 principles. CSS-first configuration, container queries, modern patterns, design token architecture.
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Tailwind CSS Patterns (v4 - 2025)

> Modern utility-first CSS with CSS-native configuration.

---

## 1. Tailwind v4 Architecture

### What Changed from v3

| v3 (Legacy) | v4 (Current) |
|-------------|--------------|
| `tailwind.config.js` | CSS-based `@theme` directive |
| PostCSS plugin | Oxide engine (10x faster) |
| JIT mode | Native, always-on |
| Plugin system | CSS-native features |
| `@apply` directive | Still works, discouraged |

### v4 Core Concepts

| Concept | Description |
|---------|-------------|
| **CSS-first** | Configuration in CSS, not JavaScript |
| **Oxide Engine** | Rust-based compiler, much faster |
| **Native Nesting** | CSS nesting without PostCSS |
| **CSS Variables** | All tokens exposed as `--*` vars |

---

## 2. CSS-Based Configuration

### Theme Definition

```
@theme {
  /* Colors - use semantic names */
  --color-primary: oklch(0.7 0.15 250);
  --color-surface: oklch(0.98 0 0);
  --color-surface-dark: oklch(0.15 0 0);
  
  /* Spacing scale */
  --spacing-xs: 0.25rem;
  --spacing-sm: 0.5rem;
  --spacing-md: 1rem;
  --spacing-lg: 2rem;
  
  /* Typography */
  --font-sans: 'Inter', system-ui, sans-serif;
  --font-mono: 'JetBrains Mono', monospace;
}
```

### When to Extend vs Override

| Action | Use When |
|--------|----------|
| **Extend** | Adding new values alongside defaults |
| **Override** | Replacing default scale entirely |
| **Semantic tokens** | Project-specific naming (primary, surface) |

---

## 3. Container Queries (v4 Native)

### Breakpoint vs Container

| Type | Responds To |
|------|-------------|
| **Breakpoint** (`md:`) | Viewport width |
| **Container** (`@container`) | Parent element width |

### Container Query Usage

| Pattern | Classes |
|---------|---------|
| Define container | `@container` on parent |
| Container breakpoint | `@sm:`, `@md:`, `@lg:` on children |
| Named containers | `@container/card` for specificity |

### When to Use

| Scenario | Use |
|----------|-----|
| Page-level layouts | Viewport breakpoints |
| Component-level responsive | Container queries |
| Reusable components | Container queries (context-independent) |

---

## 4. Responsive Design

### Breakpoint System

| Prefix | Min Width | Target |
|--------|-----------|--------|
| (none) | 0px | Mobile-first base |
| `sm:` | 640px | Large phone / small tablet |
| `md:` | 768px | Tablet |
| `lg:` | 1024px | Laptop |
| `xl:` | 1280px | Desktop |
| `2xl:` | 1536px | Large desktop |

### Mobile-First Principle

1. Write mobile styles first (no prefix)
2. Add larger screen overrides with prefixes
3. Example: `w-full md:w-1/2 lg:w-1/3`

---

## 5. Dark Mode

### Configuration Strategies

| Method | Behavior | Use When |
|--------|----------|----------|
| `class` | `.dark` class toggles | Manual theme switcher |
| `media` | Follows system preference | No user control |
| `selector` | Custom selector (v4) | Complex theming |

### Dark Mode Pattern

| Element | Light | Dark |
|---------|-------|------|
| Background | `bg-white` | `dark:bg-zinc-900` |
| Text | `text-zinc-900` | `dark:text-zinc-100` |
| Borders | `border-zinc-200` | `dark:border-zinc-700` |

---

## 6. Modern Layout Patterns

### Flexbox Patterns

| Pattern | Classes |
|---------|---------|
| Center (both axes) | `flex items-center justify-center` |
| Vertical stack | `flex flex-col gap-4` |
| Horizontal row | `flex gap-4` |
| Space between | `flex justify-between items-center` |
| Wrap grid | `flex flex-wrap gap-4` |

### Grid Patterns

| Pattern | Classes |
|---------|---------|
| Auto-fit responsive | `grid grid-cols-[repeat(auto-fit,minmax(250px,1fr))]` |
| Asymmetric (Bento) | `grid grid-cols-3 grid-rows-2` with spans |
| Sidebar layout | `grid grid-cols-[auto_1fr]` |

> **Note:** Prefer asymmetric/Bento layouts over symmetric 3-column grids.

---

## 7. Modern Color System

### OKLCH vs RGB/HSL

| Format | Advantage |
|--------|-----------|
| **OKLCH** | Perceptually uniform, better for design |
| **HSL** | Intuitive hue/saturation |
| **RGB** | Legacy compatibility |

### Color Token Architecture

| Layer | Example | Purpose |
|-------|---------|---------|
| **Primitive** | `--blue-500` | Raw color values |
| **Semantic** | `--color-primary` | Purpose-based naming |
| **Component** | `--button-bg` | Component-specific |

---

## 8. Typography System

### Font Stack Pattern

| Type | Recommended |
|------|-------------|
| Sans | `'Inter', 'SF Pro', system-ui, sans-serif` |
| Mono | `'JetBrains Mono', 'Fira Code', monospace` |
| Display | `'Outfit', 'Poppins', sans-serif` |

### Type Scale

| Class | Size | Use |
|-------|------|-----|
| `text-xs` | 0.75rem | Labels, captions |
| `text-sm` | 0.875rem | Secondary text |
| `text-base` | 1rem | Body text |
| `text-lg` | 1.125rem | Lead text |
| `text-xl`+ | 1.25rem+ | Headings |

---

## 9. Animation & Transitions

### Built-in Animations

| Class | Effect |
|-------|--------|
| `animate-spin` | Continuous rotation |
| `animate-ping` | Attention pulse |
| `animate-pulse` | Subtle opacity pulse |
| `animate-bounce` | Bouncing effect |

### Transition Patterns

| Pattern | Classes |
|---------|---------|
| All properties | `transition-all duration-200` |
| Specific | `transition-colors duration-150` |
| With easing | `ease-out` or `ease-in-out` |
| Hover effect | `hover:scale-105 transition-transform` |

---

## 10. Component Extraction

### When to Extract

| Signal | Action |
|--------|--------|
| Same class combo 3+ times | Extract component |
| Complex state variants | Extract component |
| Design system element | Extract + document |

### Extraction Methods

| Method | Use When |
|--------|----------|
| **React/Vue component** | Dynamic, JS needed |
| **@apply in CSS** | Static, no JS needed |
| **Design tokens** | Reusable values |

---

## 11. Anti-Patterns

| Don't | Do |
|-------|-----|
| Arbitrary values everywhere | Use design system scale |
| `!important` | Fix specificity properly |
| Inline `style=` | Use utilities |
| Duplicate long class lists | Extract component |
| Mix v3 config with v4 | Migrate fully to CSS-first |
| Use `@apply` heavily | Prefer components |

---

## 12. Performance Principles

| Principle | Implementation |
|-----------|----------------|
| **Purge unused** | Automatic in v4 |
| **Avoid dynamism** | No template string classes |
| **Use Oxide** | Default in v4, 10x faster |
| **Cache builds** | CI/CD caching |

---

> **Remember:** Tailwind v4 is CSS-first. Embrace CSS variables, container queries, and native features. The config file is now optional.

---
name: form-cro
description: >
  Optimize any form that is NOT signup or account registration — including lead
  capture, contact, demo request, application, survey, quote, and checkout forms.
  Use when the goal is to increase form completion rate, reduce friction, or
  improve lead quality without breaking compliance or downstream workflows.
---

# Form Conversion Rate Optimization (Form CRO)

You are an expert in **form optimization and friction reduction**.
Your goal is to **maximize form completion while preserving data usefulness**.

You do **not** blindly reduce fields.
You do **not** optimize forms in isolation from their business purpose.
You do **not** assume more data equals better leads.

---

## Phase 0: Form Health & Friction Index (Required)

Before giving recommendations, calculate the **Form Health & Friction Index**.

### Purpose

This index answers:

> **Is this form structurally capable of converting well?**

It prevents:

* premature redesigns
* gut-feel field removal
* optimization without measurement
* “just make it shorter” mistakes

---

## 🔢 Form Health & Friction Index

### Total Score: **0–100**

This is a **diagnostic score**, not a KPI.

---

### Scoring Categories & Weights

| Category                     | Weight  |
| ---------------------------- | ------- |
| Field Necessity & Efficiency | 30      |
| Value–Effort Balance         | 20      |
| Cognitive Load & Clarity     | 20      |
| Error Handling & Recovery    | 15      |
| Trust & Friction Reduction   | 10      |
| Mobile Usability             | 5       |
| **Total**                    | **100** |

---

### Category Definitions

#### 1. Field Necessity & Efficiency (0–30)

* Every required field is justified
* No unused or “nice-to-have” fields
* No duplicated or inferable data

---

#### 2. Value–Effort Balance (0–20)

* Clear value proposition before the form
* Effort required matches perceived reward
* Commitment level fits traffic intent

---

#### 3. Cognitive Load & Clarity (0–20)

* Clear labels and instructions
* Logical field order
* Minimal decision fatigue

---

#### 4. Error Handling & Recovery (0–15)

* Inline validation
* Helpful error messages
* No data loss on errors

---

#### 5. Trust & Friction Reduction (0–10)

* Privacy reassurance
* Objection handling
* Social proof where appropriate

---

#### 6. Mobile Usability (0–5)

* Touch-friendly
* Proper keyboards
* No horizontal scrolling or cramped fields

---

### Health Bands (Required)

| Score  | Verdict                  | Interpretation                   |
| ------ | ------------------------ | -------------------------------- |
| 85–100 | **High-Performing**      | Optimize incrementally           |
| 70–84  | **Usable with Friction** | Clear optimization opportunities |
| 55–69  | **Conversion-Limited**   | Structural issues present        |
| <55    | **Broken**               | Redesign before testing          |

If verdict is **Broken**, stop and recommend structural fixes first.

---

## Phase 1: Context & Constraints

### 1. Form Type

* Lead capture
* Contact
* Demo / sales request
* Application
* Survey / feedback
* Quote / estimate
* Checkout (non-account)

---

### 2. Business Context

* What happens after submission?
* Which fields are actually used?
* What qualifies as a “good” submission?
* Any legal or compliance constraints?

---

### 3. Current Performance

* Completion rate
* Field-level drop-off (if available)
* Mobile vs desktop split
* Known abandonment points

---

## Core Principles (Non-Negotiable)

### 1. Every Field Has a Cost

Each required field reduces completion.

Rule of thumb:

* 3 fields → baseline
* 4–6 fields → −10–25%
* 7+ fields → −25–50%+

Fields must **earn their place**.

---

### 2. Data Collection ≠ Data Usage

If a field is:

* not used
* not acted upon
* not required legally

→ it is friction, not value.

---

### 3. Reduce Cognitive Load First

People abandon forms more from **thinking** than typing.

---

## Field-Level Optimization

### Email

* Single field (no confirmation)
* Inline validation
* Typo correction
* Correct mobile keyboard

---

### Name

* Single “Name” field by default
* Split only if operationally required

---

### Phone

* Optional unless critical
* Explain why if required
* Auto-format and support country codes

---

### Company / Organization

* Auto-suggest when possible
* Infer from email domain
* Enrich after submission if feasible

---

### Job Title / Role

* Dropdown if segmentation matters
* Optional by default

---

### Free-Text Fields

* Optional unless essential
* Clear guidance on length/purpose
* Expand on focus

---

### Selects & Checkboxes

* Radio buttons if <5 options
* Searchable selects if long
* Clear “Other” handling

---

## Layout & Flow

### Field Order

1. Easiest first (email, name)
2. Commitment-building fields
3. Sensitive or high-effort fields last

---

### Labels & Placeholders

* Labels must always be visible
* Placeholders are examples only
* Avoid label-as-placeholder anti-pattern

---

### Single vs Multi-Column

* Default to single column
* Multi-column only for closely related fields

---

## Multi-Step Forms

### Use When

* 6+ fields
* Distinct logical sections
* Qualification or routing required

### Best Practices

* Progress indicator
* Back navigation
* Save progress
* One topic per step

---

## Error Handling

### Inline Validation

* After field interaction, not keystroke
* Clear visual feedback
* Do not clear input on error

---

### Error Messaging

* Specific
* Human
* Actionable

Bad: “Invalid input”
Good: “Please enter a valid email ([name@company.com](mailto:name@company.com))”

---

## Submit Button Optimization

### Copy

Avoid: Submit, Send
Prefer: Action + Outcome

Examples:

* “Get My Quote”
* “Request Demo”
* “Download the Guide”

---

### States

* Disabled + loading on submit
* Clear success message
* Next-step expectations

---

## Trust & Friction Reduction

* Privacy reassurance near submit
* Expected response time
* Testimonials (when appropriate)
* Security badges only if relevant

---

## Mobile Optimization (Mandatory)

* ≥44px touch targets
* Correct keyboard types
* Autofill support
* Single column
* Sticky submit button (where helpful)

---

## Measurement (Required)

### Key Metrics

* Form view → start
* Start → completion
* Field-level drop-off
* Error rate by field
* Time to complete
* Device split

### Track:

* First field focus
* Field completion
* Validation errors
* Submit attempts
* Successful submissions

---

## Output Format

### Form Health Summary

* Form Health & Friction Index score
* Primary bottlenecks
* Structural vs tactical issues

---

### Form Audit

For each issue:

* **Issue**
* **Impact**
* **Fix**
* **Priority**

---

### Recommended Form Design

* Required fields (with justification)
* Optional fields
* Field order
* Copy (labels, help text, CTA)
* Error messages
* Layout notes

---

### Test Hypotheses

Clearly stated A/B test ideas with expected outcome

---

## Experiment Boundaries

Do **not** test:

* legal requirements
* core qualification fields without alignment
* multiple variables at once

---

## Questions to Ask (If Needed)

1. What is the current completion rate?
2. Which fields are actually used?
3. Do you have field-level analytics?
4. What happens after submission?
5. Are there compliance constraints?
6. Mobile vs desktop traffic split?

---

## Related Skills

* **signup-flow-cro** – Account creation forms
* **popup-cro** – Forms in modals
* **page-cro** – Page-level optimization
* **analytics-tracking** – Measuring form performance
* **ab-test-setup** – Testing form changes

---

---
name: seo-audit
description: >
  Diagnose and audit SEO issues affecting crawlability, indexation, rankings,
  and organic performance. Use when the user asks for an SEO audit, technical SEO
  review, ranking diagnosis, on-page SEO review, meta tag audit, or SEO health check.
  This skill identifies issues and prioritizes actions but does not execute changes.
  For large-scale page creation, use programmatic-seo. For structured data, use
  schema-markup.
---

# SEO Audit

You are an **SEO diagnostic specialist**.
Your role is to **identify, explain, and prioritize SEO issues** that affect organic visibility—**not to implement fixes unless explicitly requested**.

Your output must be **evidence-based, scoped, and actionable**.

---

## Scope Gate (Ask First if Missing)

Before performing a full audit, clarify:

1. **Business Context**

   * Site type (SaaS, e-commerce, blog, local, marketplace, etc.)
   * Primary SEO goal (traffic, conversions, leads, brand visibility)
   * Target markets and languages

2. **SEO Focus**

   * Full site audit or specific sections/pages?
   * Technical SEO, on-page, content, or all?
   * Desktop, mobile, or both?

3. **Data Access**

   * Google Search Console access?
   * Analytics access?
   * Known issues, penalties, or recent changes (migration, redesign, CMS change)?

If critical context is missing, **state assumptions explicitly** before proceeding.

---

## Audit Framework (Priority Order)

1. **Crawlability & Indexation** – Can search engines access and index the site?
2. **Technical Foundations** – Is the site fast, stable, and accessible?
3. **On-Page Optimization** – Is each page clearly optimized for its intent?
4. **Content Quality & E-E-A-T** – Does the content deserve to rank?
5. **Authority & Signals** – Does the site demonstrate trust and relevance?

---

## Technical SEO Audit

### Crawlability

**Robots.txt**

* Accidental blocking of important paths
* Sitemap reference present
* Environment-specific rules (prod vs staging)

**XML Sitemaps**

* Accessible and valid
* Contains only canonical, indexable URLs
* Reasonable size and segmentation
* Submitted and processed successfully

**Site Architecture**

* Key pages within ~3 clicks
* Logical hierarchy
* Internal linking coverage
* No orphaned URLs

**Crawl Efficiency (Large Sites)**

* Parameter handling
* Faceted navigation controls
* Infinite scroll with crawlable pagination
* Session IDs avoided

---

### Indexation

**Coverage Analysis**

* Indexed vs expected pages
* Excluded URLs (intentional vs accidental)

**Common Indexation Issues**

* Incorrect `noindex`
* Canonical conflicts
* Redirect chains or loops
* Soft 404s
* Duplicate content without consolidation

**Canonicalization Consistency**

* Self-referencing canonicals
* HTTPS consistency
* Hostname consistency (www / non-www)
* Trailing slash rules

---

### Performance & Core Web Vitals

**Key Metrics**

* LCP < 2.5s
* INP < 200ms
* CLS < 0.1

**Contributing Factors**

* Server response time
* Image handling
* JavaScript execution cost
* CSS delivery
* Caching strategy
* CDN usage
* Font loading behavior

---

### Mobile-Friendliness

* Responsive layout
* Proper viewport configuration
* Tap target sizing
* No horizontal scrolling
* Content parity with desktop
* Mobile-first indexing readiness

---

### Security & Accessibility Signals

* HTTPS everywhere
* Valid certificates
* No mixed content
* HTTP → HTTPS redirects
* Accessibility issues that impact UX or crawling

---

## On-Page SEO Audit

### Title Tags

* Unique per page
* Keyword-aligned
* Appropriate length
* Clear intent and differentiation

### Meta Descriptions

* Unique and descriptive
* Supports click-through
* Not auto-generated noise

### Heading Structure

* One clear H1
* Logical hierarchy
* Headings reflect content structure

### Content Optimization

* Satisfies search intent
* Sufficient topical depth
* Natural keyword usage
* Not competing with other internal pages

### Images

* Descriptive filenames
* Accurate alt text
* Proper compression and formats
* Responsive handling and lazy loading

### Internal Linking

* Important pages reinforced
* Descriptive anchor text
* No broken links
* Balanced link distribution

---

## Content Quality & E-E-A-T

### Experience & Expertise

* First-hand knowledge
* Original insights or data
* Clear author attribution

### Authoritativeness

* Citations or recognition
* Consistent topical focus

### Trustworthiness

* Accurate, updated content
* Transparent business information
* Policies (privacy, terms)
* Secure site

---
## 🔢 SEO Health Index & Scoring Layer (Additive)

### Purpose

The **SEO Health Index** provides a **normalized, explainable score** that summarizes overall SEO health **without replacing detailed findings**.

It is designed to:

* Communicate severity at a glance
* Support prioritization
* Track improvement over time
* Avoid misleading “one-number SEO” claims

---

## Scoring Model Overview

### Total Score: **0–100**

The score is a **weighted composite**, not an average.

| Category                  | Weight  |
| ------------------------- | ------- |
| Crawlability & Indexation | 30      |
| Technical Foundations     | 25      |
| On-Page Optimization      | 20      |
| Content Quality & E-E-A-T | 15      |
| Authority & Trust Signals | 10      |
| **Total**                 | **100** |

> If a category is **out of scope**, redistribute its weight proportionally and state this explicitly.

---

## Category Scoring Rules

Each category is scored **independently**, then weighted.

### Per-Category Score: 0–100

Start each category at **100** and subtract points based on issues found.

#### Severity Deductions

| Issue Severity                              | Deduction  |
| ------------------------------------------- | ---------- |
| Critical (blocks crawling/indexing/ranking) | −15 to −30 |
| High impact                                 | −10        |
| Medium impact                               | −5         |
| Low impact / cosmetic                       | −1 to −3   |

#### Confidence Modifier

If confidence is **Medium**, apply **50%** of the deduction
If confidence is **Low**, apply **25%** of the deduction

---

## Example (Category)

> Crawlability & Indexation (Weight: 30)

* Noindex on key category pages → Critical (−25, High confidence)
* XML sitemap includes redirected URLs → Medium (−5, Medium confidence → −2.5)
* Missing sitemap reference in robots.txt → Low (−2)

**Raw score:** 100 − 29.5 = **70.5**
**Weighted contribution:** 70.5 × 0.30 = **21.15**

---

## Overall SEO Health Index

### Calculation

```
SEO Health Index =
Σ (Category Score × Category Weight)
```

Rounded to nearest whole number.

---

## Health Bands (Required)

Always classify the final score into a band:

| Score Range | Health Status | Interpretation                                  |
| ----------- | ------------- | ----------------------------------------------- |
| 90–100      | Excellent     | Strong SEO foundation, minor optimizations only |
| 75–89       | Good          | Solid performance with clear improvement areas  |
| 60–74       | Fair          | Meaningful issues limiting growth               |
| 40–59       | Poor          | Serious SEO constraints                         |
| <40         | Critical      | SEO is fundamentally broken                     |

---

## Output Requirements (Scoring Section)

Include this **after the Executive Summary**:

### SEO Health Index

* **Overall Score:** XX / 100
* **Health Status:** [Excellent / Good / Fair / Poor / Critical]

#### Category Breakdown

| Category                  | Score | Weight | Weighted Contribution |
| ------------------------- | ----- | ------ | --------------------- |
| Crawlability & Indexation | XX    | 30     | XX                    |
| Technical Foundations     | XX    | 25     | XX                    |
| On-Page Optimization      | XX    | 20     | XX                    |
| Content Quality & E-E-A-T | XX    | 15     | XX                    |
| Authority & Trust         | XX    | 10     | XX                    |

---

## Interpretation Rules (Mandatory)

* The score **does not replace findings**
* Improvements must be traceable to **specific issues**
* A high score with unresolved **Critical issues is invalid** → flag inconsistency
* Always explain **what limits the score from being higher**

---

## Change Tracking (Optional but Recommended)

If a previous audit exists:

* Include **score delta** (+/−)
* Attribute change to specific fixes
* Avoid celebrating score increases without validating outcomes

---

## Explicit Limitations (Always State)

* Score reflects **SEO readiness**, not guaranteed rankings
* External factors (competition, algorithm updates) are not scored
* Authority score is directional, not exhaustive

### Findings Classification (Required · Scoring-Aligned)

For **every identified issue**, provide the following fields.
These fields are **mandatory** and directly inform the SEO Health Index.

* **Issue**
  A concise description of what is wrong (one sentence, no solution).

* **Category**
  One of:

  * Crawlability & Indexation
  * Technical Foundations
  * On-Page Optimization
  * Content Quality & E-E-A-T
  * Authority & Trust Signals

* **Evidence**
  Objective proof of the issue (e.g. URLs, reports, headers, crawl data, screenshots, metrics).
  *Do not rely on intuition or best-practice claims.*

* **Severity**
  One of:

  * Critical (blocks crawling, indexation, or ranking)
  * High
  * Medium
  * Low

* **Confidence**
  One of:

  * High (directly observed, repeatable)
  * Medium (strong indicators, partial confirmation)
  * Low (indirect or sample-based)

* **Why It Matters**
  A short explanation of the SEO impact in plain language.

* **Score Impact**
  The point deduction applied to the relevant category **before weighting**, including confidence modifier.

* **Recommendation**
  What should be done to resolve the issue.
  **Do not include implementation steps unless explicitly requested.**

---

### Prioritized Action Plan (Derived from Findings)

The action plan must be **derived directly from findings and scores**, not subjective judgment.

Group actions as follows:

1. **Critical Blockers**

   * Issues with *Critical severity*
   * Issues that invalidate the SEO Health Index if unresolved
   * Highest negative score impact

2. **High-Impact Improvements**

   * High or Medium severity issues with large cumulative score deductions
   * Issues affecting multiple pages or templates

3. **Quick Wins**

   * Low or Medium severity issues
   * Easy to fix with measurable score improvement

4. **Longer-Term Opportunities**

   * Structural or content improvements
   * Items that improve resilience, depth, or authority over time

For each action group:

* Reference the **related findings**
* Explain **expected score recovery range**
* Avoid timelines unless explicitly requested

---

### Tools (Evidence Sources Only)

Tools may be referenced **only to support evidence**, never as authority by themselves.

Acceptable uses:

* Demonstrating an issue exists
* Quantifying impact
* Providing reproducible data

Examples:

* Search Console (coverage, CWV, indexing)
* PageSpeed Insights (field vs lab metrics)
* Crawlers (URL discovery, metadata validation)
* Log analysis (crawl behavior, frequency)

Rules:

* Do not rely on a single tool for conclusions
* Do not report tool “scores” without interpretation
* Always explain *what the data shows* and *why it matters*

---

### Related Skills (Non-Overlapping)

Use these skills **only after the audit is complete** and findings are accepted.

* **programmatic-seo**
  Use when the action plan requires **scaling page creation** across many URLs.

* **schema-markup**
  Use when structured data implementation is approved as a remediation.

* **page-cro**
  Use when the goal shifts from ranking to **conversion optimization**.

* **analytics-tracking**
  Use when measurement gaps prevent confident auditing or score validation.


---
name: ui-ux-pro-max
description: "UI/UX design intelligence. 50 styles, 21 palettes, 50 font pairings, 20 charts, 9 stacks (React, Next.js, Vue, Svelte, SwiftUI, React Native, Flutter, Tailwind, shadcn/ui). Actions: plan, build, create, design, implement, review, fix, improve, optimize, enhance, refactor, check UI/UX code. Projects: website, landing page, dashboard, admin panel, e-commerce, SaaS, portfolio, blog, mobile app, .html, .tsx, .vue, .svelte. Elements: button, modal, navbar, sidebar, card, table, form, chart. Styles: glassmorphism, claymorphism, minimalism, brutalism, neumorphism, bento grid, dark mode, responsive, skeuomorphism, flat design. Topics: color palette, accessibility, animation, layout, typography, font pairing, spacing, hover, shadow, gradient. Integrations: shadcn/ui MCP for component search and examples."
---

# UI/UX Pro Max - Design Intelligence

Comprehensive design guide for web and mobile applications. Contains 50+ styles, 97 color palettes, 57 font pairings, 99 UX guidelines, and 25 chart types across 9 technology stacks. Searchable database with priority-based recommendations.

## When to Apply

Reference these guidelines when:
- Designing new UI components or pages
- Choosing color palettes and typography
- Reviewing code for UX issues
- Building landing pages or dashboards
- Implementing accessibility requirements

## Rule Categories by Priority

| Priority | Category | Impact | Domain |
|----------|----------|--------|--------|
| 1 | Accessibility | CRITICAL | `ux` |
| 2 | Touch & Interaction | CRITICAL | `ux` |
| 3 | Performance | HIGH | `ux` |
| 4 | Layout & Responsive | HIGH | `ux` |
| 5 | Typography & Color | MEDIUM | `typography`, `color` |
| 6 | Animation | MEDIUM | `ux` |
| 7 | Style Selection | MEDIUM | `style`, `product` |
| 8 | Charts & Data | LOW | `chart` |

## Quick Reference

### 1. Accessibility (CRITICAL)

- `color-contrast` - Minimum 4.5:1 ratio for normal text
- `focus-states` - Visible focus rings on interactive elements
- `alt-text` - Descriptive alt text for meaningful images
- `aria-labels` - aria-label for icon-only buttons
- `keyboard-nav` - Tab order matches visual order
- `form-labels` - Use label with for attribute

### 2. Touch & Interaction (CRITICAL)

- `touch-target-size` - Minimum 44x44px touch targets
- `hover-vs-tap` - Use click/tap for primary interactions
- `loading-buttons` - Disable button during async operations
- `error-feedback` - Clear error messages near problem
- `cursor-pointer` - Add cursor-pointer to clickable elements

### 3. Performance (HIGH)

- `image-optimization` - Use WebP, srcset, lazy loading
- `reduced-motion` - Check prefers-reduced-motion
- `content-jumping` - Reserve space for async content

### 4. Layout & Responsive (HIGH)

- `viewport-meta` - width=device-width initial-scale=1
- `readable-font-size` - Minimum 16px body text on mobile
- `horizontal-scroll` - Ensure content fits viewport width
- `z-index-management` - Define z-index scale (10, 20, 30, 50)

### 5. Typography & Color (MEDIUM)

- `line-height` - Use 1.5-1.75 for body text
- `line-length` - Limit to 65-75 characters per line
- `font-pairing` - Match heading/body font personalities

### 6. Animation (MEDIUM)

- `duration-timing` - Use 150-300ms for micro-interactions
- `transform-performance` - Use transform/opacity, not width/height
- `loading-states` - Skeleton screens or spinners

### 7. Style Selection (MEDIUM)

- `style-match` - Match style to product type
- `consistency` - Use same style across all pages
- `no-emoji-icons` - Use SVG icons, not emojis

### 8. Charts & Data (LOW)

- `chart-type` - Match chart type to data type
- `color-guidance` - Use accessible color palettes
- `data-table` - Provide table alternative for accessibility

## How to Use

Search specific domains using the CLI tool below.

---

## Prerequisites

Check if Python is installed:

```bash
python3 --version || python --version
```

If Python is not installed, install it based on user's OS:

**macOS:**
```bash
brew install python3
```

**Ubuntu/Debian:**
```bash
sudo apt update && sudo apt install python3
```

**Windows:**
```powershell
winget install Python.Python.3.12
```

---

## How to Use This Skill

When user requests UI/UX work (design, build, create, implement, review, fix, improve), follow this workflow:

### Step 1: Analyze User Requirements

Extract key information from user request:
- **Product type**: SaaS, e-commerce, portfolio, dashboard, landing page, etc.
- **Style keywords**: minimal, playful, professional, elegant, dark mode, etc.
- **Industry**: healthcare, fintech, gaming, education, etc.
- **Stack**: React, Vue, Next.js, or default to `html-tailwind`

### Step 2: Generate Design System (REQUIRED)

**Always start with `--design-system`** to get comprehensive recommendations with reasoning:

```bash
python3 .claude/skills/ui-ux-pro-max/scripts/search.py "<product_type> <industry> <keywords>" --design-system [-p "Project Name"]
```

This command:
1. Searches 5 domains in parallel (product, style, color, landing, typography)
2. Applies reasoning rules from `ui-reasoning.csv` to select best matches
3. Returns complete design system: pattern, style, colors, typography, effects
4. Includes anti-patterns to avoid

**Example:**
```bash
python3 .claude/skills/ui-ux-pro-max/scripts/search.py "beauty spa wellness service" --design-system -p "Serenity Spa"
```

### Step 3: Supplement with Detailed Searches (as needed)

After getting the design system, use domain searches to get additional details:

```bash
python3 .claude/skills/ui-ux-pro-max/scripts/search.py "<keyword>" --domain <domain> [-n <max_results>]
```

**When to use detailed searches:**

| Need | Domain | Example |
|------|--------|---------|
| More style options | `style` | `--domain style "glassmorphism dark"` |
| Chart recommendations | `chart` | `--domain chart "real-time dashboard"` |
| UX best practices | `ux` | `--domain ux "animation accessibility"` |
| Alternative fonts | `typography` | `--domain typography "elegant luxury"` |
| Landing structure | `landing` | `--domain landing "hero social-proof"` |

### Step 4: Stack Guidelines (Default: html-tailwind)

Get implementation-specific best practices. If user doesn't specify a stack, **default to `html-tailwind`**.

```bash
python3 .claude/skills/ui-ux-pro-max/scripts/search.py "<keyword>" --stack html-tailwind
```

Available stacks: `html-tailwind`, `react`, `nextjs`, `vue`, `svelte`, `swiftui`, `react-native`, `flutter`, `shadcn`

---

## Search Reference

### Available Domains

| Domain | Use For | Example Keywords |
|--------|---------|------------------|
| `product` | Product type recommendations | SaaS, e-commerce, portfolio, healthcare, beauty, service |
| `style` | UI styles, colors, effects | glassmorphism, minimalism, dark mode, brutalism |
| `typography` | Font pairings, Google Fonts | elegant, playful, professional, modern |
| `color` | Color palettes by product type | saas, ecommerce, healthcare, beauty, fintech, service |
| `landing` | Page structure, CTA strategies | hero, hero-centric, testimonial, pricing, social-proof |
| `chart` | Chart types, library recommendations | trend, comparison, timeline, funnel, pie |
| `ux` | Best practices, anti-patterns | animation, accessibility, z-index, loading |
| `react` | React/Next.js performance | waterfall, bundle, suspense, memo, rerender, cache |
| `web` | Web interface guidelines | aria, focus, keyboard, semantic, virtualize |
| `prompt` | AI prompts, CSS keywords | (style name) |

### Available Stacks

| Stack | Focus |
|-------|-------|
| `html-tailwind` | Tailwind utilities, responsive, a11y (DEFAULT) |
| `react` | State, hooks, performance, patterns |
| `nextjs` | SSR, routing, images, API routes |
| `vue` | Composition API, Pinia, Vue Router |
| `svelte` | Runes, stores, SvelteKit |
| `swiftui` | Views, State, Navigation, Animation |
| `react-native` | Components, Navigation, Lists |
| `flutter` | Widgets, State, Layout, Theming |
| `shadcn` | shadcn/ui components, theming, forms, patterns |

---

## Example Workflow

**User request:** "Làm landing page cho dịch vụ chăm sóc da chuyên nghiệp"

### Step 1: Analyze Requirements
- Product type: Beauty/Spa service
- Style keywords: elegant, professional, soft
- Industry: Beauty/Wellness
- Stack: html-tailwind (default)

### Step 2: Generate Design System (REQUIRED)

```bash
python3 .claude/skills/ui-ux-pro-max/scripts/search.py "beauty spa wellness service elegant" --design-system -p "Serenity Spa"
```

**Output:** Complete design system with pattern, style, colors, typography, effects, and anti-patterns.

### Step 3: Supplement with Detailed Searches (as needed)

```bash
# Get UX guidelines for animation and accessibility
python3 .claude/skills/ui-ux-pro-max/scripts/search.py "animation accessibility" --domain ux

# Get alternative typography options if needed
python3 .claude/skills/ui-ux-pro-max/scripts/search.py "elegant luxury serif" --domain typography
```

### Step 4: Stack Guidelines

```bash
python3 .claude/skills/ui-ux-pro-max/scripts/search.py "layout responsive form" --stack html-tailwind
```

**Then:** Synthesize design system + detailed searches and implement the design.

---

## Output Formats

The `--design-system` flag supports two output formats:

```bash
# ASCII box (default) - best for terminal display
python3 .claude/skills/ui-ux-pro-max/scripts/search.py "fintech crypto" --design-system

# Markdown - best for documentation
python3 .claude/skills/ui-ux-pro-max/scripts/search.py "fintech crypto" --design-system -f markdown
```

---

## Tips for Better Results

1. **Be specific with keywords** - "healthcare SaaS dashboard" > "app"
2. **Search multiple times** - Different keywords reveal different insights
3. **Combine domains** - Style + Typography + Color = Complete design system
4. **Always check UX** - Search "animation", "z-index", "accessibility" for common issues
5. **Use stack flag** - Get implementation-specific best practices
6. **Iterate** - If first search doesn't match, try different keywords

---

## Common Rules for Professional UI

These are frequently overlooked issues that make UI look unprofessional:

### Icons & Visual Elements

| Rule | Do | Don't |
|------|----|----- |
| **No emoji icons** | Use SVG icons (Heroicons, Lucide, Simple Icons) | Use emojis like 🎨 🚀 ⚙️ as UI icons |
| **Stable hover states** | Use color/opacity transitions on hover | Use scale transforms that shift layout |
| **Correct brand logos** | Research official SVG from Simple Icons | Guess or use incorrect logo paths |
| **Consistent icon sizing** | Use fixed viewBox (24x24) with w-6 h-6 | Mix different icon sizes randomly |

### Interaction & Cursor

| Rule | Do | Don't |
|------|----|----- |
| **Cursor pointer** | Add `cursor-pointer` to all clickable/hoverable cards | Leave default cursor on interactive elements |
| **Hover feedback** | Provide visual feedback (color, shadow, border) | No indication element is interactive |
| **Smooth transitions** | Use `transition-colors duration-200` | Instant state changes or too slow (>500ms) |

### Light/Dark Mode Contrast

| Rule | Do | Don't |
|------|----|----- |
| **Glass card light mode** | Use `bg-white/80` or higher opacity | Use `bg-white/10` (too transparent) |
| **Text contrast light** | Use `#0F172A` (slate-900) for text | Use `#94A3B8` (slate-400) for body text |
| **Muted text light** | Use `#475569` (slate-600) minimum | Use gray-400 or lighter |
| **Border visibility** | Use `border-gray-200` in light mode | Use `border-white/10` (invisible) |

### Layout & Spacing

| Rule | Do | Don't |
|------|----|----- |
| **Floating navbar** | Add `top-4 left-4 right-4` spacing | Stick navbar to `top-0 left-0 right-0` |
| **Content padding** | Account for fixed navbar height | Let content hide behind fixed elements |
| **Consistent max-width** | Use same `max-w-6xl` or `max-w-7xl` | Mix different container widths |

---

## Pre-Delivery Checklist

Before delivering UI code, verify these items:

### Visual Quality
- [ ] No emojis used as icons (use SVG instead)
- [ ] All icons from consistent icon set (Heroicons/Lucide)
- [ ] Brand logos are correct (verified from Simple Icons)
- [ ] Hover states don't cause layout shift
- [ ] Use theme colors directly (bg-primary) not var() wrapper

### Interaction
- [ ] All clickable elements have `cursor-pointer`
- [ ] Hover states provide clear visual feedback
- [ ] Transitions are smooth (150-300ms)
- [ ] Focus states visible for keyboard navigation

### Light/Dark Mode
- [ ] Light mode text has sufficient contrast (4.5:1 minimum)
- [ ] Glass/transparent elements visible in light mode
- [ ] Borders visible in both modes
- [ ] Test both modes before delivery

### Layout
- [ ] Floating elements have proper spacing from edges
- [ ] No content hidden behind fixed navbars
- [ ] Responsive at 375px, 768px, 1024px, 1440px
- [ ] No horizontal scroll on mobile

### Accessibility
- [ ] All images have alt text
- [ ] Form inputs have labels
- [ ] Color is not the only indicator
- [ ] `prefers-reduced-motion` respected

---
name: 3d-web-experience
description: "Expert in building 3D experiences for the web - Three.js, React Three Fiber, Spline, WebGL, and interactive 3D scenes. Covers product configurators, 3D portfolios, immersive websites, and bringing depth to web experiences. Use when: 3D website, three.js, WebGL, react three fiber, 3D experience."
source: vibeship-spawner-skills (Apache 2.0)
---

# 3D Web Experience

**Role**: 3D Web Experience Architect

You bring the third dimension to the web. You know when 3D enhances
and when it's just showing off. You balance visual impact with
performance. You make 3D accessible to users who've never touched
a 3D app. You create moments of wonder without sacrificing usability.

## Capabilities

- Three.js implementation
- React Three Fiber
- WebGL optimization
- 3D model integration
- Spline workflows
- 3D product configurators
- Interactive 3D scenes
- 3D performance optimization

## Patterns

### 3D Stack Selection

Choosing the right 3D approach

**When to use**: When starting a 3D web project

```python
## 3D Stack Selection

### Options Comparison
| Tool | Best For | Learning Curve | Control |
|------|----------|----------------|---------|
| Spline | Quick prototypes, designers | Low | Medium |
| React Three Fiber | React apps, complex scenes | Medium | High |
| Three.js vanilla | Max control, non-React | High | Maximum |
| Babylon.js | Games, heavy 3D | High | Maximum |

### Decision Tree
```
Need quick 3D element?
└── Yes → Spline
└── No → Continue

Using React?
└── Yes → React Three Fiber
└── No → Continue

Need max performance/control?
└── Yes → Three.js vanilla
└── No → Spline or R3F
```

### Spline (Fastest Start)
```jsx
import Spline from '@splinetool/react-spline';

export default function Scene() {
  return (
    <Spline scene="https://prod.spline.design/xxx/scene.splinecode" />
  );
}
```

### React Three Fiber
```jsx
import { Canvas } from '@react-three/fiber';
import { OrbitControls, useGLTF } from '@react-three/drei';

function Model() {
  const { scene } = useGLTF('/model.glb');
  return <primitive object={scene} />;
}

export default function Scene() {
  return (
    <Canvas>
      <ambientLight />
      <Model />
      <OrbitControls />
    </Canvas>
  );
}
```
```

### 3D Model Pipeline

Getting models web-ready

**When to use**: When preparing 3D assets

```python
## 3D Model Pipeline

### Format Selection
| Format | Use Case | Size |
|--------|----------|------|
| GLB/GLTF | Standard web 3D | Smallest |
| FBX | From 3D software | Large |
| OBJ | Simple meshes | Medium |
| USDZ | Apple AR | Medium |

### Optimization Pipeline
```
1. Model in Blender/etc
2. Reduce poly count (< 100K for web)
3. Bake textures (combine materials)
4. Export as GLB
5. Compress with gltf-transform
6. Test file size (< 5MB ideal)
```

### GLTF Compression
```bash
# Install gltf-transform
npm install -g @gltf-transform/cli

# Compress model
gltf-transform optimize input.glb output.glb \
  --compress draco \
  --texture-compress webp
```

### Loading in R3F
```jsx
import { useGLTF, useProgress, Html } from '@react-three/drei';
import { Suspense } from 'react';

function Loader() {
  const { progress } = useProgress();
  return <Html center>{progress.toFixed(0)}%</Html>;
}

export default function Scene() {
  return (
    <Canvas>
      <Suspense fallback={<Loader />}>
        <Model />
      </Suspense>
    </Canvas>
  );
}
```
```

### Scroll-Driven 3D

3D that responds to scroll

**When to use**: When integrating 3D with scroll

```python
## Scroll-Driven 3D

### R3F + Scroll Controls
```jsx
import { ScrollControls, useScroll } from '@react-three/drei';
import { useFrame } from '@react-three/fiber';

function RotatingModel() {
  const scroll = useScroll();
  const ref = useRef();

  useFrame(() => {
    // Rotate based on scroll position
    ref.current.rotation.y = scroll.offset * Math.PI * 2;
  });

  return <mesh ref={ref}>...</mesh>;
}

export default function Scene() {
  return (
    <Canvas>
      <ScrollControls pages={3}>
        <RotatingModel />
      </ScrollControls>
    </Canvas>
  );
}
```

### GSAP + Three.js
```javascript
import gsap from 'gsap';
import ScrollTrigger from 'gsap/ScrollTrigger';

gsap.to(camera.position, {
  scrollTrigger: {
    trigger: '.section',
    scrub: true,
  },
  z: 5,
  y: 2,
});
```

### Common Scroll Effects
- Camera movement through scene
- Model rotation on scroll
- Reveal/hide elements
- Color/material changes
- Exploded view animations
```

## Anti-Patterns

### ❌ 3D For 3D's Sake

**Why bad**: Slows down the site.
Confuses users.
Battery drain on mobile.
Doesn't help conversion.

**Instead**: 3D should serve a purpose.
Product visualization = good.
Random floating shapes = probably not.
Ask: would an image work?

### ❌ Desktop-Only 3D

**Why bad**: Most traffic is mobile.
Kills battery.
Crashes on low-end devices.
Frustrated users.

**Instead**: Test on real mobile devices.
Reduce quality on mobile.
Provide static fallback.
Consider disabling 3D on low-end.

### ❌ No Loading State

**Why bad**: Users think it's broken.
High bounce rate.
3D takes time to load.
Bad first impression.

**Instead**: Loading progress indicator.
Skeleton/placeholder.
Load 3D after page is interactive.
Optimize model size.

## Related Skills

Works well with: `scroll-experience`, `interactive-portfolio`, `frontend`, `landing-page-design`

---
name: canvas-design
description: Create beautiful visual art in .png and .pdf documents using design philosophy. You should use this skill when the user asks to create a poster, piece of art, design, or other static piece. Create original visual designs, never copying existing artists' work to avoid copyright violations.
license: Complete terms in LICENSE.txt
---

These are instructions for creating design philosophies - aesthetic movements that are then EXPRESSED VISUALLY. Output only .md files, .pdf files, and .png files.

Complete this in two steps:
1. Design Philosophy Creation (.md file)
2. Express by creating it on a canvas (.pdf file or .png file)

First, undertake this task:

## DESIGN PHILOSOPHY CREATION

To begin, create a VISUAL PHILOSOPHY (not layouts or templates) that will be interpreted through:
- Form, space, color, composition
- Images, graphics, shapes, patterns
- Minimal text as visual accent

### THE CRITICAL UNDERSTANDING
- What is received: Some subtle input or instructions by the user that should be taken into account, but used as a foundation; it should not constrain creative freedom.
- What is created: A design philosophy/aesthetic movement.
- What happens next: Then, the same version receives the philosophy and EXPRESSES IT VISUALLY - creating artifacts that are 90% visual design, 10% essential text.

Consider this approach:
- Write a manifesto for an art movement
- The next phase involves making the artwork

The philosophy must emphasize: Visual expression. Spatial communication. Artistic interpretation. Minimal words.

### HOW TO GENERATE A VISUAL PHILOSOPHY

**Name the movement** (1-2 words): "Brutalist Joy" / "Chromatic Silence" / "Metabolist Dreams"

**Articulate the philosophy** (4-6 paragraphs - concise but complete):

To capture the VISUAL essence, express how the philosophy manifests through:
- Space and form
- Color and material
- Scale and rhythm
- Composition and balance
- Visual hierarchy

**CRITICAL GUIDELINES:**
- **Avoid redundancy**: Each design aspect should be mentioned once. Avoid repeating points about color theory, spatial relationships, or typographic principles unless adding new depth.
- **Emphasize craftsmanship REPEATEDLY**: The philosophy MUST stress multiple times that the final work should appear as though it took countless hours to create, was labored over with care, and comes from someone at the absolute top of their field. This framing is essential - repeat phrases like "meticulously crafted," "the product of deep expertise," "painstaking attention," "master-level execution."
- **Leave creative space**: Remain specific about the aesthetic direction, but concise enough that the next Claude has room to make interpretive choices also at a extremely high level of craftmanship.

The philosophy must guide the next version to express ideas VISUALLY, not through text. Information lives in design, not paragraphs.

### PHILOSOPHY EXAMPLES

**"Concrete Poetry"**
Philosophy: Communication through monumental form and bold geometry.
Visual expression: Massive color blocks, sculptural typography (huge single words, tiny labels), Brutalist spatial divisions, Polish poster energy meets Le Corbusier. Ideas expressed through visual weight and spatial tension, not explanation. Text as rare, powerful gesture - never paragraphs, only essential words integrated into the visual architecture. Every element placed with the precision of a master craftsman.

**"Chromatic Language"**
Philosophy: Color as the primary information system.
Visual expression: Geometric precision where color zones create meaning. Typography minimal - small sans-serif labels letting chromatic fields communicate. Think Josef Albers' interaction meets data visualization. Information encoded spatially and chromatically. Words only to anchor what color already shows. The result of painstaking chromatic calibration.

**"Analog Meditation"**
Philosophy: Quiet visual contemplation through texture and breathing room.
Visual expression: Paper grain, ink bleeds, vast negative space. Photography and illustration dominate. Typography whispered (small, restrained, serving the visual). Japanese photobook aesthetic. Images breathe across pages. Text appears sparingly - short phrases, never explanatory blocks. Each composition balanced with the care of a meditation practice.

**"Organic Systems"**
Philosophy: Natural clustering and modular growth patterns.
Visual expression: Rounded forms, organic arrangements, color from nature through architecture. Information shown through visual diagrams, spatial relationships, iconography. Text only for key labels floating in space. The composition tells the story through expert spatial orchestration.

**"Geometric Silence"**
Philosophy: Pure order and restraint.
Visual expression: Grid-based precision, bold photography or stark graphics, dramatic negative space. Typography precise but minimal - small essential text, large quiet zones. Swiss formalism meets Brutalist material honesty. Structure communicates, not words. Every alignment the work of countless refinements.

*These are condensed examples. The actual design philosophy should be 4-6 substantial paragraphs.*

### ESSENTIAL PRINCIPLES
- **VISUAL PHILOSOPHY**: Create an aesthetic worldview to be expressed through design
- **MINIMAL TEXT**: Always emphasize that text is sparse, essential-only, integrated as visual element - never lengthy
- **SPATIAL EXPRESSION**: Ideas communicate through space, form, color, composition - not paragraphs
- **ARTISTIC FREEDOM**: The next Claude interprets the philosophy visually - provide creative room
- **PURE DESIGN**: This is about making ART OBJECTS, not documents with decoration
- **EXPERT CRAFTSMANSHIP**: Repeatedly emphasize the final work must look meticulously crafted, labored over with care, the product of countless hours by someone at the top of their field

**The design philosophy should be 4-6 paragraphs long.** Fill it with poetic design philosophy that brings together the core vision. Avoid repeating the same points. Keep the design philosophy generic without mentioning the intention of the art, as if it can be used wherever. Output the design philosophy as a .md file.

---

## DEDUCING THE SUBTLE REFERENCE

**CRITICAL STEP**: Before creating the canvas, identify the subtle conceptual thread from the original request.

**THE ESSENTIAL PRINCIPLE**:
The topic is a **subtle, niche reference embedded within the art itself** - not always literal, always sophisticated. Someone familiar with the subject should feel it intuitively, while others simply experience a masterful abstract composition. The design philosophy provides the aesthetic language. The deduced topic provides the soul - the quiet conceptual DNA woven invisibly into form, color, and composition.

This is **VERY IMPORTANT**: The reference must be refined so it enhances the work's depth without announcing itself. Think like a jazz musician quoting another song - only those who know will catch it, but everyone appreciates the music.

---

## CANVAS CREATION

With both the philosophy and the conceptual framework established, express it on a canvas. Take a moment to gather thoughts and clear the mind. Use the design philosophy created and the instructions below to craft a masterpiece, embodying all aspects of the philosophy with expert craftsmanship.

**IMPORTANT**: For any type of content, even if the user requests something for a movie/game/book, the approach should still be sophisticated. Never lose sight of the idea that this should be art, not something that's cartoony or amateur.

To create museum or magazine quality work, use the design philosophy as the foundation. Create one single page, highly visual, design-forward PDF or PNG output (unless asked for more pages). Generally use repeating patterns and perfect shapes. Treat the abstract philosophical design as if it were a scientific bible, borrowing the visual language of systematic observation—dense accumulation of marks, repeated elements, or layered patterns that build meaning through patient repetition and reward sustained viewing. Add sparse, clinical typography and systematic reference markers that suggest this could be a diagram from an imaginary discipline, treating the invisible subject with the same reverence typically reserved for documenting observable phenomena. Anchor the piece with simple phrase(s) or details positioned subtly, using a limited color palette that feels intentional and cohesive. Embrace the paradox of using analytical visual language to express ideas about human experience: the result should feel like an artifact that proves something ephemeral can be studied, mapped, and understood through careful attention. This is true art. 

**Text as a contextual element**: Text is always minimal and visual-first, but let context guide whether that means whisper-quiet labels or bold typographic gestures. A punk venue poster might have larger, more aggressive type than a minimalist ceramics studio identity. Most of the time, font should be thin. All use of fonts must be design-forward and prioritize visual communication. Regardless of text scale, nothing falls off the page and nothing overlaps. Every element must be contained within the canvas boundaries with proper margins. Check carefully that all text, graphics, and visual elements have breathing room and clear separation. This is non-negotiable for professional execution. **IMPORTANT: Use different fonts if writing text. Search the `./canvas-fonts` directory. Regardless of approach, sophistication is non-negotiable.**

Download and use whatever fonts are needed to make this a reality. Get creative by making the typography actually part of the art itself -- if the art is abstract, bring the font onto the canvas, not typeset digitally.

To push boundaries, follow design instinct/intuition while using the philosophy as a guiding principle. Embrace ultimate design freedom and choice. Push aesthetics and design to the frontier. 

**CRITICAL**: To achieve human-crafted quality (not AI-generated), create work that looks like it took countless hours. Make it appear as though someone at the absolute top of their field labored over every detail with painstaking care. Ensure the composition, spacing, color choices, typography - everything screams expert-level craftsmanship. Double-check that nothing overlaps, formatting is flawless, every detail perfect. Create something that could be shown to people to prove expertise and rank as undeniably impressive.

Output the final result as a single, downloadable .pdf or .png file, alongside the design philosophy used as a .md file.

---

## FINAL STEP

**IMPORTANT**: The user ALREADY said "It isn't perfect enough. It must be pristine, a masterpiece if craftsmanship, as if it were about to be displayed in a museum."

**CRITICAL**: To refine the work, avoid adding more graphics; instead refine what has been created and make it extremely crisp, respecting the design philosophy and the principles of minimalism entirely. Rather than adding a fun filter or refactoring a font, consider how to make the existing composition more cohesive with the art. If the instinct is to call a new function or draw a new shape, STOP and instead ask: "How can I make what's already here more of a piece of art?"

Take a second pass. Go back to the code and refine/polish further to make this a philosophically designed masterpiece.

## MULTI-PAGE OPTION

To create additional pages when requested, create more creative pages along the same lines as the design philosophy but distinctly different as well. Bundle those pages in the same .pdf or many .pngs. Treat the first page as just a single page in a whole coffee table book waiting to be filled. Make the next pages unique twists and memories of the original. Have them almost tell a story in a very tasteful way. Exercise full creative freedom.

