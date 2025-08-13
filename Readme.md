# fish-git-emojis

**Enhanced Fish shell plugin for Git commits with emojis and JIRA integration**

This is an enhanced fork of [Gazorby's fish-git-emojis](https://github.com/Gazorby/fish-git-emojis) with significant improvements for professional development workflows.

## 🆕 What's New in This Fork

This fork includes several enhancements over the original:

- **🔄 Improved Format**: Conventional commit type before emoji (`feat: ✨ new feature` vs `✨ feat: new feature`)
- **🎫 JIRA Integration**: Automatic JIRA issue ID detection and appending from branch names
- **📝 Commit Body Support**: Add detailed commit descriptions with `-b` flag
- **📏 Conventional Commit Validation**: Enforces 50-character subject line limit with helpful error messages
- **🌿 Smart Branch Creation**: `gbranch` command for JIRA-integrated branch workflows
- **📦 Enhanced Commands**: Additional commit types and improved functionality

Shortcuts to commit with Gitmoji messages following [Conventional Commits specification](https://www.conventionalcommits.org/en/v1.0.0/) and [Angular commit guidelines](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines).

## 🚀 Installation

### Using Fisher
```bash
# Install this enhanced fork
fisher add srizzling/fish-git-emojis

# Or install the original version
fisher add Gazorby/fish-git-emojis
```

### Optional Dependencies
For full functionality, install these optional tools:

```bash
# For JIRA integration (gbranch command)
brew install ankitpokhrel/jira-cli/jira-cli
brew install gum

# Configure JIRA CLI
jira init
```

## 🔧 Usage

### Basic Syntax
```bash
command [scope] "<commit message>" [-b "<commit body>"]
```

### Commit Body Support
Add detailed commit descriptions using the `-b` flag:

```bash
# Basic usage
gfeat "add user authentication"
# Result: feat: ✨ add user authentication (PROJ-123)

# With scope
gfeat auth "add login endpoint"
# Result: feat(auth): ✨ add login endpoint (PROJ-123)

# With detailed body
gfeat auth -b "Implements JWT-based authentication with refresh tokens.\n\nIncludes:\n- Login/logout endpoints\n- Token validation middleware\n- Session management" "add authentication system"
```

### Conventional Commit Validation
- Subject lines are limited to 50 characters (including type, scope, emoji, JIRA ID)
- Body text is automatically wrapped at 75 characters
- Helpful error messages show exactly how many characters you can use

### JIRA Integration
- **Automatic JIRA ID Detection**: Extracts issue IDs from branch names (e.g., `feature/PROJ-123-add-login` → `(PROJ-123)`)
- **Smart Branch Creation**: Use `gbranch` to create branches from your current JIRA sprint issues
- **Pattern Recognition**: Supports various branch naming patterns with JIRA issue keys

## 📋 Available Commands

| Command     | Emoji | Type      | Purpose |
|-------------|-------|-----------|----------|
| `gfeat`     | ✨    | feat      | New features |
| `gfix`      | 🐛    | fix       | Bug fixes |
| `gdocs`     | 📝    | docs      | Documentation |
| `gstyle`    | 🎨    | style     | Code style/formatting |
| `gref`      | ♻️    | refactor  | Code refactoring |
| `gperf`     | ⚡    | perf      | Performance improvements |
| `gtest`     | ✅    | test      | Tests |
| `gci`       | 👷    | ci        | CI/CD changes |
| `gchore`    | 🧹    | chore     | Maintenance tasks |
| `gdepup`    | ⬆️    | chore     | Dependency upgrades |
| `gdepdown`  | ⬇️    | chore     | Dependency downgrades |
| `gwip`      | 🚧    | wip       | Work in progress (random messages) |
| `gbranch`   | -     | -         | JIRA-integrated branch creation |

### Special Commands

#### `gbranch` - JIRA Branch Creation
Interactive command that fetches your current JIRA sprint issues and helps create properly named branches:

```bash
gbranch
# 1. Fetches current sprint issues assigned to you
# 2. Interactive selection (supports multiple issues)
# 3. Auto-generates branch names like: feature/PROJ-123-add-user-auth
# 4. Handles name conflicts and sanitization
```

**Requirements for `gbranch`:**
- [JIRA CLI](https://github.com/ankitpokhrel/jira-cli) configured
- [gum](https://github.com/charmbracelet/gum) for interactive selections

#### `gwip` - Work in Progress
Creates WIP commits with random humorous messages from [whatthecommit.com](http://whatthecommit.com):

```bash
gwip
# Result: wip: 🚧 Fixed a bug I introduced last week
```

## 💡 Examples

### Basic Commits
```bash
# Simple feature
gfeat "add user registration"
# → feat: ✨ add user registration (PROJ-123)

# With scope
gfix api "handle null responses"
# → fix(api): 🐛 handle null responses (PROJ-123)

# Documentation
gdocs "update API documentation"
# → docs: 📝 update API documentation (PROJ-123)
```

### Commits with Body
```bash
# Detailed feature description
gfeat -b "Implements comprehensive user management system.\n\nFeatures:\n- User registration/login\n- Profile management\n- Role-based permissions\n- Email verification" "add user management system"

# Bug fix with explanation
gfix -b "The API was returning 500 errors when user data was null.\n\nFixed by adding proper null checks and returning appropriate 400 errors with descriptive messages." "fix null pointer in user API"
```

### Error Handling
```bash
# Subject too long
gfeat "this is a really long commit message that exceeds the fifty character limit"
# → Error: Subject line is 87 characters (max 50)
# → Including type, scope, emoji, and JIRA ID, your subject can be max 42 characters
# → Current subject: 'this is a really long commit message...' (79 chars)
```

## 🛠️ Development Workflow

1. **Create Branch**: `gbranch` to select JIRA issue and create branch
2. **Make Changes**: Develop your feature/fix
3. **Commit Work**: Use appropriate `g*` commands with `-b` for detailed descriptions
4. **Follow Convention**: Automatic validation ensures consistent commit format

## 📝 License

[MIT](https://github.com/Gazorby/fish-git-emojis/blob/master/LICENSE)

## 🙏 Credits

Original project by [Gazorby](https://github.com/Gazorby). This fork adds JIRA integration, commit body support, and enhanced validation while maintaining compatibility with the original API.
