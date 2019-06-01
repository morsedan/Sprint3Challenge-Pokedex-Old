//
//  SearchViewController.swift
//  Sprint3Challenge-Pokedex
//
//  Created by morse on 6/1/19.
//  Copyright © 2019 morse. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var typesLabel: UILabel!
    @IBOutlet var abilitiesLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var saveButton: UIButton!
    
    var pokemonController: PokemonController?
    var pokemon: Pokemon?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        hideLabels()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        
        pokemonController?.searchForPokemon(with: searchTerm, completion: { result in
            if let pokemon = try? result.get() {
                DispatchQueue.main.async {
                    self.pokemon = pokemon
                    self.displayPokemon(with: self.pokemon)
                }
            }
        })
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let pokemon = self.pokemon else { return }
        pokemonController?.savePokemon(pokemon)
        self.navigationController?.popViewController(animated: true)
    }
    
    func displayPokemon(with pokemon: Pokemon?) {
        guard let pokemon = pokemon else { return }
        var typeArray: [String] = []
        var abilitiesArray: [String] = []
        for item in pokemon.types {
            typeArray.append(item.type.name)
        }
        for item in pokemon.abilities {
            abilitiesArray.append(item.ability.name)
        }
        showLabels()
        
        nameLabel.text = pokemon.name
        idLabel.text = "ID: \(pokemon.id)"
        typesLabel.text = typeArray.joined(separator: ", ")
        abilitiesLabel.text = abilitiesArray.joined(separator: ", ")
        pokemonController?.fetchImage(at: pokemon.sprites.frontShiny, completion: { result in
            if let image = try? result.get() {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        })
    }
    
    func hideLabels() {
        nameLabel.isHidden = true
        imageView.isHidden = true
        idLabel.isHidden = true
        typesLabel.isHidden = true
        abilitiesLabel.isHidden = true
        saveButton.isHidden = true
    }
    
    func showLabels() {
        nameLabel.isHidden = false
        imageView.isHidden = false
        idLabel.isHidden = false
        typesLabel.isHidden = false
        abilitiesLabel.isHidden = false
        saveButton.isHidden = false
    }
}
