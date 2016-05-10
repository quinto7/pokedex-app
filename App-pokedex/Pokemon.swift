//
//  Pokemon.swift
//  App-pokedex
//
//  Created by Quinto Cossio on 1/5/16.
//  Copyright © 2016 Quinto Cossio. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name:String!
    private var _pokedexId:Int!
    private var _description:String!
    private var _type:String!
    private var _defense:String!
    private var _height:String!
    private var _weight:String!
    private var _attack:String!
    private var _pokemonUrl:String!
    private var _nextEvolutionTxt:String!
    private var _nextEvolutionId:String!
    private var _nextEvolutionLvl:String!
    
    var description:String{
        //Lo hacemos seguro al programa. Si no llega a haber un valor, la app no va crashear solo va a dar un string vacio
        if _description == nil{
            _description = ""
        }
        return _description
    }
    
    var type:String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    
    var defense:String{
        if _defense == nil{
            _defense = ""
        }
        return _defense
    }
    
    var height:String{
        if _height == nil{
            _height = ""
        }
        return _height
    }
    
    var weight:String{
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    
    var attack:String{
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    
    
    
    var nextEvolutionTxt:String{
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var nextEvolutionId:String{
        if _nextEvolutionId == nil{
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLvl:String{
        if _nextEvolutionLvl == nil{
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    //Name y pokedexId no pueden ser nil porque los inicializamos
    var name:String{
        
        return _name
    }
    
    var pokedexId:Int{
        
        return _pokedexId
    }
    
    init(name:String, pokedexId:Int){
        self._name = name
        self._pokedexId = pokedexId
        
        //Setear el url cada vez que se crea un nuevo pokemon
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)"
        
    }
    
    //El paramentro quiere decir que cuando la descarga haya terminado y depende que se haya puesto como paramentro va a ejecutar ese bloque de codigo
    func downloadPokemonDetail(completed: DownloadComplete){
        
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { response in
            
            let result = response.result
            
            //Empezamos a agarrar los valores del JSON para meterlos adentro de las variables (Parsing)
            //Prmiero: transforma el JSON en un Dictionary
            if let dict = result.value as? Dictionary<String, AnyObject>{
                
                //Segundo: Agarro del dictionary el value weight y lo trasnformo en el tipo que esta en JSON. Dsps lo asigno a la variable
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
                if let height = dict["height"] as? String{
                    self._height = height
                }
                if let attack = dict["attack"] as? Int{
                    self._attack = "\(attack)"  //Lo convierto al Int en String
                }
                if let defense = dict["defense"] as? Int{
                    self._defense = "\(defense)"
                }
                
                print(self._weight)
                print(self._attack)
                print(self._defense)
                print(self._height)
                
                if let types = dict["types"] as? [Dictionary<String,String>] where types.count > 0{
                    //Tomo el primer valor del array que es el primer type y ese valor tiene un dictionary donde agarro la key "name"
                    if let name = types[0]["name"]{
                        self._type = name.capitalizedString
                    }
                    //Si hay mas de un type va a unirse al type
                    if types.count > 1{
                        
                        var x = 1
                        while x < types.count{
                            if let name = types[1]["name"]{
                                self._type! += " / \(name.capitalizedString)"
                                x += 1
                            }
                        }
                        
                        
                    }
    
                }else{
                    self._type = ""
                    
                }
                print(self._type)
                
                
                if let descriptionArray = dict["descriptions"] as? [Dictionary<String, String>] where descriptionArray.count > 0{
                    
                    if let url = descriptionArray[0]["resource_uri"]{
                        //Hacemos otra request
                        //La resource_uri es una url donde esta la description. A URL base se le agrega esto
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            
                            let descriptionResult = response.result
                            
                            if let descriptionDict = descriptionResult.value as? Dictionary<String, AnyObject>{
                                
                                if let description = descriptionDict["description"] as? String{
                                    self._description = description
                                    print(self._description)
                                    
                                    
                                }
                                
                                
                            }
                            completed()
                            //Parametro: se pone aca porque es lo ultimo que se carga
                            
                            
                        }
                        
                    }
                        
                }else{
                    
                    self._description = ""
                    
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0{
                    
                    if let to = evolutions[0]["to"] as? String{
                        
                        //Filtramos la palabra mega. Si en el pokemon dice mega, no va aparacer nada
                        if to.rangeOfString("mega") == nil{
                            //Neceistamos el numero del resource_uri para poder saber el pokemon y cargar la imagen
                            if let uri = evolutions[0]["resource_uri"] as? String{
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "") //Remplazo el String que doy por el otro que doy
                                let number = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = number
                                self._nextEvolutionTxt = to
                                
                                if let nextLvl = evolutions[0]["level"] as? Int{
                                    self._nextEvolutionLvl = "\(nextLvl)"
                                }
                                
                                print(self._nextEvolutionLvl)
                                print(self._nextEvolutionTxt)
                                print(self._nextEvolutionId)
                            }
                        }
                    }
                }
                
            }
            
            
        }
        
    }
}