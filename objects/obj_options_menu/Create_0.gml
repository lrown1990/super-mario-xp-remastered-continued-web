arrProps = ["character", "parallax", "transitions", "exit"];
characterList = ["mario", "luigi"];
parallaxActivated = [true, false];
smoothTransitionsActivated = [true, false];

optionsArr = [characterList, parallaxActivated, smoothTransitionsActivated];

arrCurrent = 0;
arrListCurrent = 0;

// The entries start from how the preferences stand NOW, not from scratch.
// They used to be fixed at zero, and since the step re-assigns the global
// from the highlighted entry, simply opening the options was enough to end
// up as Mario again after choosing Luigi.
arrCharacterCurrent = (global.character == "luigi") ? 1 : 0;
arrParallaxCurrent = global.parallaxScrolling ? 0 : 1;
arrTransitionCurrent = global.smoothTransitions ? 0 : 1;

// it only writes to disk when something actually changes
cambiato = false;

pressed = false;
pressedOption = false;

headerText = "";
bodyText = "";