arrProps = ["character", "parallax", "transitions", "exit"];
characterList = ["mario", "luigi"];
parallaxActivated = [true, false];
smoothTransitionsActivated = [true, false];

optionsArr = [characterList, parallaxActivated, smoothTransitionsActivated];

arrCurrent = 0;
arrListCurrent = 0;

// Le voci partono da come stanno le preferenze ADESSO, non da capo.
// Prima erano fisse a zero, e siccome il passo riassegna la variabile globale
// dalla voce evidenziata, bastava entrare nelle opzioni per ritrovarsi Mario
// anche dopo aver scelto Luigi.
arrCharacterCurrent = (global.character == "luigi") ? 1 : 0;
arrParallaxCurrent = global.parallaxScrolling ? 0 : 1;
arrTransitionCurrent = global.smoothTransitions ? 0 : 1;

// si scrive su disco solo quando qualcosa cambia davvero
cambiato = false;

pressed = false;
pressedOption = false;

headerText = "";
bodyText = "";