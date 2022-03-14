# PokedexApp

This project is a simple iOS PokedexApp that allows you to discover all the Pokémons listed in PokéAPI. This App has been implemented using Swift on a xCode environment. 

## Features

- When you access the App, several service calls are performed. `/fetchPokemonList` retrieves the basic list of Pokémons names. This service call is paginated, so more calls are performed as long as you scroll down the name's list on the main screen. Whereas `/fetchPokemon` retrieves the detail of a chosen Pokémon. Several of this last service call are performed in order to retrieve the details of the Pokémons you can find under "Recommendations".
- From the main screen you can have access to the Pokémon detail UIViewController or to the search UIViewController.

## Dev details

- Cocoapods has been used
- PokemonAPI is used to have easily access to the whole PokeAPI resources and methods
- Lottie is a pod used to perform animations, in order to have a nice and smooth user experience
- Unit Tests have been implemented on HomePageViewModel, where 93% of coverage has been reached (two of the methods are untestable because they are UI-related)
- URLSession has been predisposed to allow caching.
