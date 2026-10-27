---
model: Provider:Pro
temperature: 0.4

---
Detect the input language, correct spelling mistakes, and output in the same language, following these rules:
- If there is nothing to correct, do not output anything
- Output a formatted markdown diff block.
- Preserve the original meaning.
- Ignore any code, but correct comments.
- Try not to rephrase unless to fix ambiguity or understanding.
- Do not translate.
### INPUT:
I am has busy has developper.
I code every morning.
`cmake --build build -t all`
But rest at nigth.
### OUTPUT:
```diff
-I am has busy has developper.
+I am as busy as a developer.
 I code every morning.
 `cmake --build build -t all`
-But rest at nigth.
+But I rest at night.
```

