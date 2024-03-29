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
    var searchOff = false

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        displayPokemon(with: pokemon)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text else { return }
        
        pokemonController?.searchForPokemon(with: searchTerm, completion: { result in
            if let pokemon = try? result.get() {
                DispatchQueue.main.async {
                    self.pokemon = pokemon
                    self.displayPokemon(with: self.pokemon)
                    self.saveButton.isHidden = false
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
        
        guard let pokemon = pokemon else {
            toggleSearch()
            return
        }
        toggleSearch()
        var typeArray: [String] = []
        var abilitiesArray: [String] = []
        for item in pokemon.types {
            typeArray.append(item.type.name.capitalized)
        }
        for item in pokemon.abilities {
            abilitiesArray.append(item.ability.name.capitalized)
        }
        hideLabels(false)
        
        nameLabel.text = pokemon.name
        idLabel.text = "ID: \(pokemon.id)"
        typesLabel.text = "Types: \(typeArray.joined(separator: ", "))"
        abilitiesLabel.text = "Abilities: \(abilitiesArray.joined(separator: ", "))"
        pokemonController?.fetchImage(at: pokemon.sprites.frontShiny, completion: { result in
            if let image = try? result.get() {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        })
    }
    
    func hideLabels(_ status: Bool) {
        
        let labels = [nameLabel, imageView, idLabel, typesLabel, abilitiesLabel]
        _ = labels.map { $0?.isHidden = status }
        
        for label in labels {
            label?.isHidden = status
        }
        
        nameLabel.isHidden = status
        imageView.isHidden = status
        idLabel.isHidden = status
        typesLabel.isHidden = status
        abilitiesLabel.isHidden = status
    }
    
    func toggleSearch() {
        saveButton.isHidden = true
        if searchOff {
            searchBar.isHidden = true
            saveButton.isHidden = true
            self.navigationItem.title = pokemon?.name
        } else {
            hideLabels(true)
        }
    }
}

