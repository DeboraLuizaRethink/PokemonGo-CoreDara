//
//  PokeAgendaViewController.swift
//  PokemonGo
//
//  Created by Debora Luiza on 19/01/23.
//

import UIKit

class PokeAgendaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pokemonCapturados: [Pokemon] = []
    var pokemonNaoCapturados: [Pokemon] = []

    @IBAction func voltarMapa(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coreDataPokemon = CoreDataPokemon()
        
        self.pokemonCapturados = coreDataPokemon.recuperarPokemonCapturado(capturado: true)
        self.pokemonNaoCapturados = coreDataPokemon.recuperarPokemonCapturado(capturado: false)
         
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Capturados"
        }else{
            return "Não Capturados"
        }
    }
    
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
           return self.pokemonCapturados.count
        }else{
          return self.pokemonNaoCapturados.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pokemon: Pokemon
        
        if indexPath.section == 0 {
            pokemon = self.pokemonCapturados[indexPath.row]
        }else{
            pokemon = self.pokemonNaoCapturados[indexPath.row]
        }
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "celula")
        cell.textLabel?.text = pokemon.nome
        cell.imageView?.image = UIImage(named: pokemon.nomeImagem!)
        
        return cell
    }

}
