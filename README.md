# In-Class Activity 06 – CustomPainter Smiley Lab

**Student:** Akshitha Sainath Sanagarapu (Panther ID: 003027780)
**Course:** Mobile App Development  
**Activity:** In-Class Activity 06 – Smiley Face  

## Overview

This Flutter application demonstrates custom drawing using `CustomPainter` and the Canvas API. The app builds an interactive smiley face using drawing primitives and connects user interactions to application state.

The implementation follows the design rule:

> User actions change state → state is passed into the painter → the painter draws the current configuration.

## Features

- Custom smiley face drawn using `CustomPainter`
- Canvas drawing primitives including circles, arcs, and rectangles
- Mood slider that changes the face appearance
- Dynamic face color based on mood
- Hat drawn as an additional painter layer
- Three named face styles:
  - Classic
  - Sleepy
  - Surprised
- Tap interaction to change the face
- Long-press interaction to reset the configuration
- Undo functionality using saved previous configurations
- Responsive drawing based on the available canvas size

## Face Styles

### Classic
Displays the standard smiley face with circular eyes and a curved smile.

### Sleepy
Displays closed eyes and a smaller relaxed smile.

### Surprised
Displays circular eyes and an open circular mouth.

## State and Painting

The application keeps the current face configuration in widget state. User interactions update this state using `setState()`.

The current configuration is then passed to `SmileyPainter`, which is responsible only for drawing the face.

`shouldRepaint()` determines when the custom painter needs to redraw after the configuration changes.

## Interaction

The application supports multiple forms of interaction:

- **Slider:** changes the mood value.
- **Face selector:** switches between Classic, Sleepy, and Surprised.
- **Tap on face:** changes the current face.
- **Long press on face:** resets the face configuration.
- **Undo:** restores the previous configuration from the undo history.

## Project Structure

```text
smiley_painter/
├── android/
├── docs/
│   └── graduate_critical_thinking.md
├── ios/
├── lib/
│   └── main.dart
├── test/
├── web/
├── README.md
└── pubspec.yaml