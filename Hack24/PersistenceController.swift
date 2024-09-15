//
//  PersistenceController.swift
//  Hack24
//
//  Created by Edgar Patricio Olalde Sepulveda on 15/09/24.
//

import CoreData

class PersistenceController {
    // Singleton para acceder al controlador globalmente
    static let shared = PersistenceController()

    // Contenedor de Persistencia que encapsula el modelo de datos de CoreData
    let container: NSPersistentContainer

    init() {
        // El nombre 'ModelName' debe coincidir con tu archivo `.xcdatamodeld`
        container = NSPersistentContainer(name: "DataModel")
        
        // Cargar los almacenamientos persistentes (la base de datos de CoreData)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                // Manejo de errores de configuración, idealmente esto debería ser manejado más elegantemente
                fatalError("Error al inicializar CoreData: \(error), \(error.userInfo)")
            }
        }
    }
}
