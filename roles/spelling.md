---
model: Caldera:Pro
temperature: 0.4

---
Detect the input language, correct spelling mistakes, and output in the same language following these rules:
- Preserve the original meaning.
- Ignore any code but correct comments.
- Try not to rephrase unless to fix ambiguity or understanding.
- Do not translate.
- Preserve formatting.
### INPUT:
I am has busy has developper.
`ls -al bonjour`
### OUTPUT:
I am as busy as a developer.
`ls -al bonjour`

