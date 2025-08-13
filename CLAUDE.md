# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

fish-git-emojis is a Fish shell plugin that provides shortcuts for creating Git commits with emoji and conventional commit messages. This is a fork that places the conventional commit type before the emoji (e.g., `feat: ✨ my new feat`).

## Commands

### Development Commands
- **No build/test/lint commands** - This is a simple Fish shell plugin with no formal build system
- **Installation**: `fisher add Gazorby/fish-git-emojis`
- **Manual testing**: Source individual function files to test changes, e.g., `source functions/gfeat.fish`

### Git Commit Commands
- `gfeat [scope] "message"` - Feature commits (✨)
- `gfix [scope] "message"` - Bug fix commits (🐛)
- `gdocs [scope] "message"` - Documentation commits (📝)
- `gstyle [scope] "message"` - Style/formatting commits (🎨)
- `gref [scope] "message"` - Refactor commits (♻️)
- `gperf [scope] "message"` - Performance commits (⚡)
- `gtest [scope] "message"` - Test commits (✅)
- `gci [scope] "message"` - CI/CD commits (👷)
- `gchore [scope] "message"` - Maintenance commits (🧹)
- `gdepup [scope] "message"` - Dependency upgrade commits (⬆)
- `gdepdown [scope] "message"` - Dependency downgrade commits (⬇️)
- `gwip` - Work in progress commits with random messages (🚧)
- `gbranch` - Interactive JIRA-integrated branch creation

### Commit Body Support
All git commit commands support the `-b` flag for adding commit body:
- `gfeat -b "detailed description" "short subject"`
- `gfeat scope -b "body with\nnewlines" "subject"`
- Body text is automatically wrapped at 75 characters per conventional commits
- Supports newlines using `\n` in the body text

### Conventional Commit Validation
- Subject lines are limited to 50 characters (including type, scope, emoji, JIRA ID)
- Commands will error with helpful guidance if subject exceeds limit
- Shows maximum allowed characters for user's subject text
- Follows conventional commit specification for consistent formatting

## Architecture

### Core Components

1. **Central Commit Function**: `functions/_gc.fish`
   - Handles all commit logic, JIRA ID extraction, and message formatting
   - Pattern: `_gc <emoji> <type> [scope] <message>`
   - Automatically appends JIRA IDs from branch names
   - Special handling for WIP commits (uses --no-verify)

2. **Command Wrappers**: Each git command in `functions/` is a simple wrapper
   - Example: `function gfeat; _gc "✨" "feat" $argv; end`
   - All commands follow the same pattern, calling `_gc` with specific emoji and type

3. **Branch Management**: `functions/gbranch.fish`
   - Requires `jira` CLI and `gum` tools
   - Fetches current sprint issues
   - Interactive issue selection
   - Automatic branch name generation

4. **Plugin Configuration**: `conf.d/fish_git_emojis.fish`
   - Handles uninstallation cleanup

### Key Implementation Details

- **JIRA Integration**: Regex pattern `[A-Z]+-[0-9]+` extracts issue IDs from branch names
- **Message Formatting**: Supports optional scope parameter (e.g., `feat(auth): ✨ message`)
- **WIP Behavior**: Uses whatthecommit.com API for random commit messages
- **Branch Sanitization**: Converts spaces to hyphens, removes special characters

## External Dependencies

- **Required**: Fish shell, Git
- **Optional**: JIRA CLI and gum (for `gbranch` functionality)
- **Network**: curl (for `gwip` random messages)

## Development Tips

- When modifying commit functions, test by sourcing the file directly
- The `_gc` function is the central point for all commit logic modifications
- JIRA ID extraction happens automatically - no need to include in commit messages
- Branch names are automatically sanitized in `gbranch` function