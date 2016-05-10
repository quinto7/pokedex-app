//
//  ViewController.swift
//  App-pokedex
//
//  Created by Quinto Cossio on 1/5/16.
//  Copyright © 2016 Quinto Cossio. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var musicPlayer:AVAudioPlayer!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done  //cambio el boton del teclado por Done
        
        initAudio()
        parsePokemonCSV()
    
    }
    
    func initAudio(){
        
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        
        do{
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        }catch let err as NSError{
            
            print(err.debugDescription)
        }
        
    }
    
    //CSV PARSING:Va a agarrar la data del archivo CSV y la va "parse" aca para mostrar en la app
    func parsePokemonCSV(){
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do{
            let csv = try CSV(contentsOfURL: path)
            //Agarramos las rows desde el archivo .csv
            let rows = csv.rows
            
            //Va a intererar por las rows para crear los objetos y ponerlos en el array "pokemon"
            
            for row in rows{
                
                //Cada row es un dictionary que estan todos adentro de un array.
                //Agarramos de la row el "id" (Ver pokemon.csv) y lo convertimos en Int
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                //Creamos una instance de un pokemon y agrego la instance (todos los pokemones) al array
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
                
                
            }
            
        }catch let err as NSError{
            
            print(err.debugDescription)
        }
        
        
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode{
            return filteredPokemon.count
        }
        
        return pokemon.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let poke: Pokemon!
        if inSearchMode{
            poke = filteredPokemon[indexPath.row]
            
        }else{
            poke = pokemon[indexPath.row]
        }
        
        performSegueWithIdentifier("PokemonDetailVC", sender: poke)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell{
            
            let pokemons:Pokemon!
            
            //Si estamos buscando en la SearchBar solo van aparecer los filtrados sino aparecen todos
            if inSearchMode{
                pokemons = filteredPokemon[indexPath.row]
            }else{
                pokemons = pokemon[indexPath.row]
            }
            
            cell.configureCell(pokemons)
            
            return cell
        }else{
            
            return UICollectionViewCell()
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(105, 105)
    }

    @IBAction func playMusicPressed(sender: UIButton) {
        
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.2
        }else{
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    //Para que se vaya el teclado cuando apreto el boton "Search" ->Puedo cambiar el nombre en viewDidLoad (Ver arriba)
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == ""{
            inSearchMode = false
            view.endEditing(true)  //Para que se vaya el teclado cuando esta vacio la searchBar
            collection.reloadData()
        }else{
            inSearchMode = true
            //Para filtrar:
            //1)Agarro la palabra de la searchBar y la paso a lowercase para que no haya error cuando filtre
            let lower = searchBar.text!.lowercaseString
            //2)Paso del array pokemon a filtredarray y filtro los resultados segun un criterio
            //3)Criterio: El filtro va a pasar por todos los valores del array. 
            //$0 es como hacer pokemon[23], es decir retrieve un valor del array. Solo que este va a pasar por todos los valores y agarrar los nombres.
            //El filtro se ejecuta cada vez que escibimos en la searchBar
            filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
            collection.reloadData()
            
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PokemonDetailVC"{
            if let detailVC = segue.destinationViewController as? PokemonDetailVC{
                //Agarro el sender (poke) que puse antes en perfrom segue with identifier
                if let poke = sender as? Pokemon{
                    //Hago que la variable del otro viewcontroller (DetailVC) sea igual a nuestro array de este viewcontroller
                    detailVC.pokemon = poke
                    
                }
            }
            
        }
        
    }

        
        
        
}

