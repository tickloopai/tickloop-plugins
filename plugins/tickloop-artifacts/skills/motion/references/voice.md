# Asked for a voiceover

This page says what to tell someone who asks for a voiceover or a narration, or to use an audio recording or music file
of theirs, and where in the chat to say it. Also read all of [recording.md](recording.md) if your tools can record a voice (`ArtifactEdit` lists the action `speak`;
go by the names you see, and don't search for them), or if the film
speaks already (it holds `modules/narration.js`, or its `film/script` sets `narration`: look in its data, with a `list`
of `modules` and a `get` of `film/script`). Where that page differs from this one or from SKILL.md, it goes first.
Without either, Motion adds no voice and never offers one; either way, it never uses an audio recording or music file
of theirs. **A new film is made all the same,** with the words on screen in its scenes.

## What they are told

| They want | Ahead of the questions | In the questions | In the close |
| --- | --- | --- | --- |
| a voiceover, a narration, anyone's voice (you can't record) | I can't add a voiceover. | There will be no voiceover: the words will be on screen. | It has no voiceover, since I can't add one: the words are on screen. |
| their own audio recording in it, even as the voiceover (use this row, not the first) | I can't use your recording. | Your recording can't be used: the animation will have text on screen. Once it is finished, Export saves it as a video, and any video editor can add your recording to that. | I couldn't use your recording, but any video editor can add it to the video that Export saves. |
| a music file of theirs in it | I can't use your music file. | Your music file can't be used: I'll compose a score. | I couldn't use your music file, but any video editor can add it to the video that Export saves. |

Say it in their language, and as short. It is a plain fact about Motion, not a refusal: give no reason and no word of
time or place (not even "here"), and never let it hold up the questions or the film. A tip or an offer may go anywhere but
in the line ahead of the questions.

## Where

Chat can hide what you write ahead of a tool call. So they are told in **the last text of the turn in which they ask**:

- **A mere question** ("can it do voiceover?"): "No, I can't add a voiceover to an animation." Start nothing.
- **A film they have already seen:** do the rest of the ask as usual, and say "I can't add a voiceover." last (in a
  close: these same words, where the close bullet puts them). You may offer to put the words on screen, if they aren't there.
- **A question or a refusal of your own that ends the turn:** "I can't add a voiceover, so I'll put the words on
  screen." goes with it. When kinds.md turns the whole film down, leave the voice out of that no (it is two sentences,
  with no "can't"). If they take the film it offers, tell them as for any new film.
- **A close** (of a film, a plan or a rough cut): a sentence of its own, after its first sentence ("Here's your animation.")
  and the film's url, if that close gives one. It isn't the close's one short sentence more.

**A new film, with the questions.** They are told in three places: ahead of the question cards, in them, and again in
the next close. Each is needed; none stands in for another.

- **Ahead of them:** the sentence opens SKILL.md's one line before the `AskUserQuestion` call, before the words on the
  quick picks, and nothing else of yours goes there. In any language but English the sentence is the whole line: the line must stay far under 200 bytes. Write the line
  last, with no call or thought between it and `AskUserQuestion`.
- **In them:** the first sentence of the questions' words opens the first question's text, whichever it is:
  "There will be no voiceover: the words will be on screen. Which style should it have?" Keep that text under about 120
  characters. What doesn't fit, an answer to a question of theirs too, waits for the close.

## Never

- No speech made by code (the stage has no speech), no audio file as an asset, and don't ask for a recording or wait
  for one.
- No promise of a voice at any other time or place.
- A push changes nothing: give the same answer.
