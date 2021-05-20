# fish-git-emojis

Note: This is a forked version of developed by [Gazorby](https://github.com/Gazorby) over at [fish-git-emoji](https://github.com/Gazorby/fish-git-emojis/blob/master)

I've forked that repo and made the following amendments:

- I prefer having the convention commit type before the emoji, i.e `feat: ✨ my new feat` vs `✨ feat: my new feat"`

Shortcuts to commit with Gitmoji messages. Default emojis are inspired from [gitmoji](https://gitmoji.carloscuesta.me/), and messages follow [Conventional Commits specification](https://www.conventionalcommits.org/en/v1.0.0/) and [Angular commit messages guidelines]([https://link](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines)).

## 🚀 Install

Using [fisher](https://github.com/jorgebucaran/fisher) :

```console
fisher add Gazorby/fish-git-emojis
```

## 🔧 Usage

`command [<scope>] <commit message> [options]`

options :

```console
-k --breaking           Add a "!" after the type/scope to indicate a breaking change
-f --footer STRING      Add a footer. Can be used multiple times for multiple footers
-b --b-footer STRING    Add a breaking change footer. The message will be prepended by "BREAKING CHANGE:". Can be used multiple time for multiple footers
```

| Command | Emoji |
|-------- | ----------- |
| gbuild  | 👷 build/chore |
| gci     | 💚 Continuous integration |
| gdocs    | 📝 Documentation |
| gfix    | 🐛 Bugfix |
| gfeat   | ✨ New feature |
| gperf   | ⚡️ Improve performance |
| gref    | ♻️ Code refactoring |
| gstyle  | 🎨 Code style |
| gtest   | ✅ Test |

## 📝 License

[MIT](https://github.com/Gazorby/fish-git-emojis/blob/master/LICENSE)
