//
//  ViewController.swift
//  PokemonGo
//
//  Created by Debora Luiza on 18/01/23.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    var gerenciadorLocalizacao = CLLocationManager()
    var contador = 0
    var coreDataPokemon: CoreDataPokemon!
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // quem vai gerenciar o mapa é essa classe
        mapa.delegate = self
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        
        //recuperar os pokemon
        self.coreDataPokemon = CoreDataPokemon()
        self.pokemons = self.coreDataPokemon.recuperarTodosPokemon()
        
        //exibir pokemons
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            
            if let coordenadas = self.gerenciadorLocalizacao.location?.coordinate{
                
                //gerar pokemon aleatorio
                let totalPokemon = UInt32(self.pokemons.count)
                let indicePokemonAleatorio = arc4random_uniform(totalPokemon)
                
                let pokemon = self.pokemons[ Int(indicePokemonAleatorio) ]
                
                let anotacao = PokemonAnotacao(coordenadas: coordenadas, pokemon: pokemon)
                
                let latAleatoria = (Double(arc4random_uniform(500)) - 250) / 100000.0
                let longAleatoria = (Double(arc4random_uniform(500)) - 250) / 100000.0
                
                anotacao.coordinate.latitude += latAleatoria
                anotacao.coordinate.longitude += longAleatoria
                
                self.mapa.addAnnotation(anotacao)
            }
            
            
        }
    }
    
    func mapView(_ mapView: MKMapView,viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        let anotacaoView = MKAnnotationView(annotation: annotation, reuseIdentifier:  nil)
        
        if annotation is MKUserLocation {
            anotacaoView.image = UIImage(named: "player")
        }else{
            let pokemon = (annotation as! PokemonAnotacao).pokemon
            anotacaoView.image = UIImage(named: pokemon.nomeImagem!)
            
        }
        
        var frame = anotacaoView.frame
        frame.size.height = 40
        frame.size.width = 40
        
        anotacaoView.frame = frame
        
        return anotacaoView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let anotacao = view.annotation
        let pokemon = (anotacao as! PokemonAnotacao).pokemon
        mapView.deselectAnnotation(anotacao, animated: true)
        
        if anotacao is MKUserLocation {
          return
        }
        
        if let coordAnotacao = anotacao?.coordinate{
            let regiao = MapKit.MKCoordinateRegion.init(center: coordAnotacao, latitudinalMeters: 200, longitudinalMeters: 200)
            mapa.setRegion(regiao, animated: true)
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            
            if let coord = self.gerenciadorLocalizacao.location?.coordinate {
                if  self.mapa.visibleMapRect.contains(MKMapPoint(coord)) {
                    self.coreDataPokemon.salvarPokemon(pokemon: pokemon)
                    self.mapa.removeAnnotation(anotacao!)
                    
                    //alerta
                    let alertController = UIAlertController(title: "Parabéns", message: "Você capturou o pokémon: \(String(describing: pokemon.nome))", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok", style: .default)
                    alertController.addAction(ok)
                    self.present(alertController, animated: true)
                    
                }else{
                    //alerta
                    let alertController = UIAlertController(title: "Que pena!", message: "O pokémon \(String(describing: pokemon.nome)) está muito longe para ser capturado", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok", style: .default)
                    alertController.addAction(ok)
                    self.present(alertController, animated: true)
                }
            }
        }
       
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if contador < 3{
            self.centralizar()
            contador += 1
        }else{
            gerenciadorLocalizacao.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse && status != .notDetermined{
            //alerta informando que a localização é necessária
            let alertController = UIAlertController(title: "Permissão de localização",
                                                    message: "para que você possa caçar pokémon, precisamos de sua localização! por favor, habilite!!",
                                                    preferredStyle: .alert)
            
            let acaoConfiguracoes = UIAlertAction(title: "Abrir configurações", style: .default) { alertaConfig in
                
                if let configuracoes = NSURL(string: UIApplication.openNotificationSettingsURLString){
                    UIApplication.shared.open(configuracoes as URL)
                }
                
            }
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default)
            
            
            alertController.addAction(acaoConfiguracoes)
            alertController.addAction(acaoCancelar)
            present(alertController, animated: true)
        }
    }

    func centralizar(){
        if let coordenadas = gerenciadorLocalizacao.location?.coordinate{
            let regiao = MapKit.MKCoordinateRegion.init(center: coordenadas, latitudinalMeters: 200, longitudinalMeters: 200)
            mapa.setRegion(regiao, animated: true)
        }
    }
    
    @IBAction func centralizarJogador(_ sender: Any) {
        self.centralizar()
    }
    
    @IBAction func abrirPokedex(_ sender: Any) {
        
    }
}

