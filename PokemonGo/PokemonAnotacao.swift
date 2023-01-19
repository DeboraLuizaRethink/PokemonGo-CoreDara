//
//  PokemonAnotacao.swift
//  PokemonGo
//
//  Created by Debora Luiza on 19/01/23.
//

import UIKit
import MapKit

class PokemonAnotacao: NSObject , MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    
    init(coordenadas: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordenadas
        self.pokemon = pokemon
    }
}
