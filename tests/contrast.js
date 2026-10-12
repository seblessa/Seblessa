'use strict';

const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const root = path.resolve(__dirname, '..');
const config = require(path.join(root, '.hyper.js')).config;
const rgb = hex => hex.slice(1).match(/../g).map(channel => parseInt(channel, 16));
const blend = (foreground, background, alpha) => foreground.map((v, i) => alpha * v + (1 - alpha) * background[i]);
const luminance = colour => colour.map(v => {
  const channel = v / 255;
  return channel <= 0.04045 ? channel / 12.92 : ((channel + 0.055) / 1.055) ** 2.4;
}).reduce((sum, v, i) => sum + v * [0.2126, 0.7152, 0.0722][i], 0);
const contrast = (a, b) => {
  const [dark, light] = [luminance(a), luminance(b)].sort((x, y) => x - y);
  return (light + 0.05) / (dark + 0.05);
};

assert.equal(config.backgroundColor, config.hyperTransparent.backgroundColor);
assert(config.hyperTransparent.opacity > 0 && config.hyperTransparent.opacity < 1);
// shortcut: models alpha blending; recheck visually if macOS vibrancy changes.
const background = blend(rgb(config.backgroundColor), [255, 255, 255], config.hyperTransparent.opacity);
const selection = config.selectionColor.match(/^rgba\((\d+), (\d+), (\d+), ([\d.]+)\)$/);
assert(selection, 'Selection must specify an RGBA colour');
const selectedBackground = blend(selection.slice(1, 4).map(Number), background, Number(selection[4]));
const sources = ['.p10k.zsh', '.zshrc'].map(file => fs.readFileSync(path.join(root, file), 'utf8')).join('\n');
const colours = new Set([
  config.foregroundColor,
  config.cursorColor,
  ...Object.entries(config.colors).filter(([name]) => name !== 'black').map(([, value]) => value),
  ...Array.from(sources.matchAll(/(?:FOREGROUND|COLOR)='(#[\da-f]{6})'|%F\{(#[\da-f]{6})\}|fg=(#[\da-f]{6})/gi), m => m[1] || m[2] || m[3]),
]);
let minimum = Infinity;
for (const colour of colours) {
  for (const surface of [background, selectedBackground, rgb('#2A3D55')]) {
    const ratio = contrast(rgb(colour), surface);
    assert(ratio >= 4.5, `${colour} has insufficient contrast: ${ratio.toFixed(2)}:1`);
    minimum = Math.min(minimum, ratio);
  }
}
console.log(`Text colours: minimum modelled contrast ${minimum.toFixed(2)}:1 with transparent and selected backgrounds.`);
