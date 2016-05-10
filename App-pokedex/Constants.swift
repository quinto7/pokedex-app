//
//  Constants.swift
//  App-pokedex
//
//  Created by Quinto Cossio on 8/5/16.
//  Copyright © 2016 Quinto Cossio. All rights reserved.
//

import Foundation

let URL_BASE = "http://pokeapi.co"
let URL_POKEMON = "/api/v1/pokemon/"

//Creamos un custom "Clousure" que es un bloque de codigo que se va a ejecutar cuando yo elija
typealias DownloadComplete = () -> ()