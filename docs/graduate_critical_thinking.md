# Graduate Critical Thinking – `shouldRepaint`

**Student:** Akshitha Sainath Sanagarapu (Panther ID: 003027780) 
**Activity:** In-Class Activity 06 – Drawing with Flutter  
**Date:** September 30, 2026

## Purpose

The purpose of this experiment was to compare two implementations of
`shouldRepaint()` in the `SmileyPainter` custom painter and observe how
they affect the application's behavior.

The application uses a `CustomPainter` to draw the face, eyes, mouth,
border, and hat. The drawing changes based on two values:

- `mood`
- `faceType`

## Version 1 – Always Repaint

The first implementation tested was:

```dart
@override
bool shouldRepaint(covariant SmileyPainter oldDelegate) {
  return true;
}
```

I tested this version by moving the mood slider and switching between
the Classic, Sleepy, and Surprised faces.

The application continued to work correctly, and I did not notice a
visual difference while interacting with it. However, this
implementation always reports that repainting is necessary whenever
Flutter asks the painter whether it should repaint.

## Version 2 – Conditional Repaint

The second implementation tested was:

```dart
@override
bool shouldRepaint(covariant SmileyPainter oldDelegate) {
  return oldDelegate.mood != mood ||
      oldDelegate.faceType != faceType;
}
```

I repeated the same interactions by moving the mood slider and changing
between the different face types.

Again, the application behaved correctly and there was no noticeable
visual difference compared with the `return true` implementation.

The difference is that this implementation checks the properties that
actually affect the drawing. A repaint is requested when the `mood`
changes or when the `faceType` changes.

## Observation

Both implementations produced the same visible result during my test.

The important difference is the repaint decision. Using `return true`
always reports that repainting is needed, while comparing `mood` and
`faceType` makes the decision depend on whether the painter's relevant
state actually changed.

I did not perform frame-rate or performance profiling during this
experiment, so I cannot claim a measured performance difference between
the two versions.

## Final Implementation

I kept the conditional implementation in the final application:

```dart
@override
bool shouldRepaint(covariant SmileyPainter oldDelegate) {
  return oldDelegate.mood != mood ||
      oldDelegate.faceType != faceType;
}
```

This implementation directly reflects the values used by the
`SmileyPainter` and avoids requesting a repaint when those drawing
inputs have not changed.