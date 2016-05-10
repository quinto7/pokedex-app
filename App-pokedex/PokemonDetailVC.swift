//
//  PokemonDetailVC.swift
//  App-pokedex
//
//  Created by Quinto Cossio on 4/5/16.
//  Copyright © 2016 Quinto Cossio. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var pokemonImg: UIImageView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var pokedexIdLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var nextEvoLbl: UILabel!
    @IBOutlet weak var actualEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    
    var pokemon:Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Estan guardados ya en la app ->entonces puedo cargrlos desde aca
        
        nameLbl.text = pokemon.name
        let img = UIImage(named: "\(pokemon.pokedexId)")
        pokemonImg.image = img
        actualEvoImg.image = img
        
        //No cargar las requests aca. Crashea. Hay q ponerlo adentro de la func de abajo
        
        pokemon.downloadPokemonDetail { 
            //Esto se va a ejecutar cuando la descarga haya terminado. Si se ejecuta en viewDidLoad hubiera crasheado. 
          self.updateUI()
            
        }
    }
    
    func updateUI(){
        descriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        defenseLbl.text = pokemon.defense
        attackLbl.text = pokemon.attack
        pokedexIdLbl.text = "\(pokemon.pokedexId)"
        
        if pokemon.nextEvolutionId == ""{
            nextEvoLbl.text = "No Evolution"
            nextEvoImg.hidden = true
        }else{
            nextEvoImg.hidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution: \(pokemon.nextEvolutionTxt)"
            nextEvoLbl.text = str
            
            if pokemon.nextEvolutionLvl != ""{
                str += " - LVL \(pokemon.nextEvolutionLvl)"
            }
            
        }
        
    }

   
    @IBAction func backBtnPressed(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }

}
