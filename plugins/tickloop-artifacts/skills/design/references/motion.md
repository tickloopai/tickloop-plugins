# Motion

When the user asks for animation, a playable or dynamic demonstration, an automatic sequence or a loop, generate visible changes over time. A clickable prototype alone fulfills an interaction request; a motion request needs its own timed behavior. Keep posters, print pieces and other static work static unless the user asks for motion.

## Build the requested sequence

1. Name the elements that change, their states, order, duration and loop or end state. Follow the user's timing; for a continuous product demonstration, a readable 8–12 second loop is a useful default.
2. Write every visual element and state in the artboard's `<x-dc>` markup or inline SVG; the states a timeline steps through are `state` fields that `renderVals()` turns into the values and `<sc-if>` branches the template reads. Keep the artboard readable before any animation starts. Use CSS keyframes first (in `<helmet><style>`), then SVG attributes or WAAPI; use a small timeline in the `Component` class when states need coordination. Layout stays in flex/grid.
3. Animate the actual subject: for a work demonstration, task rows appear, a passage is highlighted, a comment appears, and the result changes. Give viewers time to read, restore the initial state at the loop boundary, and run the next cycle without accumulating timers or listeners. A hover effect or a brief toast alone does not fulfill an automatic demonstration.
4. Keep real controls usable. A simulated demonstration changes its own `state`; it never submits a real form or navigates away on a timer. Pause the affected demonstration when user input would otherwise be overwritten.

The artboard keeps the rules of SKILL.md's skeleton and [Format](format.md): all UI is template markup, never script-built. `"is_interactive": true` marks working controls, not a timeline.

## Motion controls

Declare the artboard's participation on its `<html>` with `data-tickloop-motion="on"`; use `"off"` when motion should initially be disabled. Ordinary static artboards omit this attribute. The preview's Motion control freezes and resumes participating CSS animations. Put decorative CSS motion inside `@media (prefers-reduced-motion: no-preference)` and preserve a complete static state for reduced motion.

For WAAPI and timelines in the `Component` class, cooperate with the read-only `window.tickloopMotion` API:

- `enabled` is the current boolean state. It starts false until the preview host configures the document.
- `subscribe(listener)` immediately calls `listener(enabled)`, then calls it when enabled changes, and returns an unsubscribe function.
- On false, pause owned WAAPI animations and cancel owned timers or RAF callbacks while preserving progress. On true, resume or start one loop. Arbitrary JavaScript is not globally paused by the host.
- If the API is absent in a standalone export, run according to the system's reduced-motion preference. If the API exists and is false, keep motion stopped until its subscription enables it.

Start the subscription in `componentDidMount` and undo all of it (timers, listeners, the subscription) in `componentWillUnmount`. Replay reloads the whole artboard from its starting state. Preview-ticket renewal and navigation may also reload it; only the Motion preference is restored, not its `state`.

## Example

A status line that steps through three phases while a dot glows. Adapt the labels to the user's language; the dot's glow is CSS, the phases a timer in the class:

```html
<!doctype html>
<html lang="en" data-tickloop-motion="on">
<head>
<meta charset="utf-8">
<title>Inventory sync</title>
<script src="./support.js"></script>
</head>
<body>
<x-dc>
<helmet>
<style>
body{margin:0}
@keyframes tick-glow { 0%, 100% { opacity: 0.35; } 50% { opacity: 0.8; } }
@media (prefers-reduced-motion: no-preference) { .tick-glow { animation: tick-glow 6s ease-in-out infinite; } }
</style>
</helmet>
<div style="width: 640px; height: 360px; box-sizing: border-box; padding: 64px; display: flex; flex-direction: column; justify-content: center; gap: 24px; background: #f3f6f4; color: #14211b; font-family: system-ui, sans-serif">
<h1 style="margin: 0; font-size: 40px; line-height: 1.15">Inventory sync</h1>
<div style="display: flex; align-items: center; gap: 12px">
<svg width="16" height="16" viewBox="0 0 16 16" aria-hidden="true"><circle class="tick-glow" cx="8" cy="8" r="8" fill="#1f6b4f" style="opacity: 0.35"></circle></svg>
<p style="margin: 0; font-size: 22px" aria-live="polite">{{status}}</p>
</div>
</div>
</x-dc>
<script type="text/x-dc" data-dc-script data-props='{"$preview":{"width":640,"height":360}}'>
class Component extends DCLogic {
  constructor(props) {
    super(props);
    this.state = { phase: 0 };
    this.phases = ['Ready', 'Working', 'Updated'];
    this.update = this.update.bind(this);
  }
  componentDidMount() {
    this.reduced = window.matchMedia('(prefers-reduced-motion: reduce)');
    this.reduced.addEventListener('change', this.update);
    const motion = window.tickloopMotion;
    this.unsubscribe = motion ? motion.subscribe(this.update) : () => {};
    if (!motion) this.update();
  }
  componentWillUnmount() {
    this.stop();
    this.unsubscribe();
    this.reduced.removeEventListener('change', this.update);
  }
  update() {
    const motion = window.tickloopMotion;
    if (this.reduced.matches || (motion && !motion.enabled)) this.stop();
    else if (this.timer === undefined) {
      this.timer = setInterval(() => this.setState(({ phase }) => ({ phase: (phase + 1) % this.phases.length })), 2000);
    }
  }
  stop() {
    clearInterval(this.timer);
    this.timer = undefined;
  }
  renderVals() {
    return { status: this.phases[this.state.phase] };
  }
}
</script>
</body>
</html>
```

WAAPI follows the same subscription: keep the animation objects (on elements reached through a `ref` from `renderVals()`), pause them initially, and call their `play()` or `pause()` when the effective state changes. Respect reduced motion on that path too. Avoid creating or restarting animations while the API is false.

## When asked to verify over time

Use preview tools only when the user asks to see or check, or to diagnose an error the user reported. Otherwise finish after saving; if you think a check is needed, ask the user first and wait for their answer.

For that requested check, use `DesignShow` for the initial view and load errors, then `DesignScreenshots` with sequential `steps` and delays to observe distinct moments in the same fresh preview. Each step supplies `code` and a delay of at most 5,000 ms. For a six-second loop, observe its initial, middle, end and next-cycle states. Inspect visible text, opacity or position as well as screenshots; one screenshot and successful clicks do not establish playback. Check Motion off freezes the current state, on resumes, Replay returns to the initial state, and reduced motion stays readable.

When no preview is available, report temporal and visual behavior as unverified. State what was actually checked; reading source or updating this Skill does not verify a real model's generated animation.
