//
//  ViewController.swift
//  ios_socket
//
//  Created by Mario Peñate Fariñas on 28/03/2020.
//  Copyright © 2020 Mario Peñate Fariñas. All rights reserved.
//

import UIKit
import SocketSwift

struct EugenioData {
    let header: UInt32
    let data: UInt16
    let crc: UInt8
    
    func getData() -> [UInt8] {
        return header.byteArrayLittleEndian + data.byteArrayLittleEndian + [crc]
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var eugenioData = EugenioData(header: 0x04030201, data: 0x0605, crc: 0x07)
        
        do {
            let client = try Socket(.inet, type: .stream, protocol: .tcp)
            try client.connect(port: 1234, address: "127.0.0.1")
//            try client.write(eugenioData.getData())
            try client.write(&eugenioData, length: MemoryLayout<EugenioData>.size)
            
            let arrayRecived: [UInt8] = [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
            
            // Example 1
//            let rawPointer = UnsafeRawPointer(arrayRecived)
//            let pointer = rawPointer.assumingMemoryBound(to: EugenioData.self)
//            let value = pointer.pointee
//            print(value)
            
            // Example 2
//            let x = UnsafeRawPointer(arrayRecived)
//            let y = x.bindMemory(to: EugenioData.self, capacity: MemoryLayout<EugenioData>.size)
//            print(y.pointee)
            
            // Recieved example 1
//            var recieved = EugenioData(header: 0, data: 0, crc: 0)
//            print(recieved)
//            _ = try client.read(&recieved, size: MemoryLayout<EugenioData>.size)
//            print(recieved)
            
            // Recieved example 2
            var buffer = Array<UInt8>(repeating: 0, count: 64)
            print(buffer)
            let length2 = try client.read(&buffer, size: buffer.count)
            print(length2)
            print(buffer)
            let ptr2 = UnsafeRawPointer(buffer)
            let z = ptr2.bindMemory(to: EugenioData.self, capacity: MemoryLayout<EugenioData>.size)
            print(z.pointee)
            
        }
        catch {
            debugPrint("FAIL")
        }
        
    }

}

extension UInt32 {
    
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt32>.size)
    }
    
    var byteArrayLittleEndian: [UInt8] {
        return [
            UInt8(self & 0x000000FF),
            UInt8((self & 0x0000FF00) >> 8),
            UInt8((self & 0x00FF0000) >> 16),
            UInt8((self & 0xFF000000) >> 24),
        ]
    }
}

extension UInt16 {
    
    var byteArrayLittleEndian: [UInt8] {
        return [
            UInt8(self & 0x000000FF),
            UInt8((self & 0x0000FF00) >> 8),
        ]
    }
    
}
