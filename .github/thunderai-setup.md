# ThunderAI Setup

Re-apply after a fresh install: ≡ → Add-ons and Themes → ThunderAI → Preferences.

## Connection (Preferences tab)

| Setting         | Value                    |
| --------------- | ------------------------ |
| Connection Type | `Ollama API (Local LLM)` |
| Host Address    | `http://localhost:11434` |
| Ollama Model    | `llama3:latest`          |
| Temperature     | *(blank)*                |
| Force JSON output | ☑ on                   |

## Manage Tags Settings

| Option                               | State |
| ------------------------------------ | ----- |
| Use specific Model and API           | ☐     |
| Maximum number of tags               | `1`   |
| Exclusions exact match               | ☐     |
| Hide excluded tags                   | ☐     |
| First letter uppercase               | ☐     |
| Force language                       | ☐     |
| Add tags automatically               | ☑     |
| Only add tags to emails in the inbox | ☑     |
| Use only these tags                  | ☑     |
| Force existing tags                  | ☐     |

### Use only these tags

```
social
study
work
```

### Prompt text

```
You are an email triage assistant. Classify the importance of the
following email to the recipient. Choose EXACTLY ONE tag from this
allowed list: {%tags_full_list%}
Guidance:
- work: Everything related to financial offers, extra work, work at BOSCH, and meetings.
- study: Everything related to university, study trips, and any notification from a university institution or authority. Everything a student would find important.
- social: Everything that does not fall under work, study, or advertising, but might interest me as a person trying to socialize.
Context:
- Sender: {%author%}
- Subject: {%mail_subject%}
- Body: {%mail_text_body%}
Respond in JSON only, no other text, in exactly this format:
{"tags": ["work"]}
```

## Auto-tag accounts (bottom of Manage Tags Settings)

- ☑ `vitaliyovich.oleg@gmail.com`
- ☑ `vitaliyovich.oleh@gmail.com`
- ☑ `haiduk.oleh@gmail.com`
- ☐ `Local Folders`
