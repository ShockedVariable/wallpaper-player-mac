//
//  WEScene.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/9/4.
//

import Foundation

struct WESceneCamera: Codable {
    var center: String
    var sys: String
    var up: String
}

struct WESceneGeneralOrthogonalProjection: Codable {
    var height: Int
    var width: Int
}

struct WESceneGeneralBloomStrength: Codable {
    var user: String
    var value: Double
}

struct WESceneGeneral: Codable {
    var ambientcolor: String
    var bloom: Bool
    var bloomhdrfeather: Double
    var bloomhdrscatter: Double
    var bloomhdrstrength: Double
    var bloomhdrthreshold: Double
    var bloomstrength: WESceneGeneralBloomStrength
    var bloomthreshold: Double
    var camerafade: Bool
    var cameraparallax: Bool
    var cameraparallaxamount: Double
    var cameraparallaxdelay: Double
    var cameraparallaxmouseinfluence: Double
    var camerapreview: Bool
    var camerashake: Bool
    var camerashakeamplitude: Double
    var camerashakeroughness: Double
    var camerashakespeed: Double
    var clearcolor: String
    var clearenabled: Bool
    var farz: Double
    var fov: Double
    var hdr: Bool
    var nearz: Double
    var orthogonalprojection: WESceneGeneralOrthogonalProjection
    var skylightcolor: String
    var zoom: Double
}

struct WESceneImage: WESceneObjectProtocol {
    var alignment: String
    var alpha: Double
    var angles: String
    var brightness: Int
    var color: String
    var colorBlendMode: Bool
    var copybackground: Bool
    var effects: WESceneEntityEffect
    var id: Int
    var image: String
    var ledsource: Bool
    var locktransforms: Bool
    var origin: String
    var parallaxDepth: String
    var perspective: Bool
    var scale: String
    var size: String
    var solid: Bool
    var visible: Bool
}

struct WESceneParticleInstanceOverride: Codable {
    var colorn: String
    var id: Int
}

struct WESceneParticle: WESceneObjectProtocol {
    var angles: String
    var id: Int
    var instanceoverride: WESceneParticleInstanceOverride
    var locktransforms: Bool
    var name: String
    var origin: String
    var parallaxDepth: String
    var particle: String
    var scale: String
    var visible: WESceneObjectVisible
}

struct WESceneObjectVisibleObject: Codable {
    var user: String
    var value: Bool
}

enum WESceneObjectVisible: Codable {
    case bool(Bool)
    case object(WESceneObjectVisibleObject)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(WESceneObjectVisibleObject.self) {
            self = .object(x)
            return
        }
        throw DecodingError.typeMismatch(Self.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Scene Object Visible Property"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .object(let x):
            try container.encode(x)
        }
    }
}

struct WESceneEntityTextScriptProperties: Codable {
    var delimiter: String
    var showSeconds: Bool
    var use24hFormat: Bool
}

struct WESceneEntityText: Codable {
    var script: String
    var scriptproperties: WESceneEntityTextScriptProperties
    var value: String
}

struct WESceneEntityEffectPassConstantCombos: Codable {
    var EDGES: Int?
    var SAMPLES: Int?
    var VERTICAL: Int?
    var BLENDMODE: Int?
}

struct WESceneEntityEffectPassConstantShaderValues: Codable {
    var noiseamount: Double
    var noisescale: Double
}

struct WESceneEntityEffectPass: Codable {
    var combos: WESceneEntityEffectPassConstantCombos?
    var constantshadervalues: WESceneEntityEffectPassConstantShaderValues?
    var id: Int
    var textures: [String?]?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let combos = combos {
            try container.encode(combos, forKey: .combos)
        }
        
        if let constantshadervalues = constantshadervalues {
            try container.encode(constantshadervalues, forKey: .constantshadervalues)
        }
        
        try container.encode(id, forKey: .id)
        
        if let textures = textures {
            try container.encode(textures, forKey: .textures)
        }
    }
}

struct WESceneEntityEffect: Codable {
    var file: String
    var id: String
    var name: String
    var passes: [WESceneEntityEffectPass]
}

struct WESceneEntity: WESceneObjectProtocol {
    var alpha: Double
    var anchor: String
    var angles: String
    var backgroundbrightness: Double
    var backgroundcolor: String
    var brightness: Double
    var color: String
    var colorBlendMode: Int
    var copybackground: Bool
    var effects: [WESceneEntityEffect]
    var font: String
    var horizontalalign: String
    var id: Int
    var ledsource: Bool
    var locktransforms: Bool
    var name: String
    var opaquebackground: Bool
    var origin: String
    var padding: Int
    var parallaxDepth: String
    var perspective: Bool
    var pointsize: Double
    var scale: String
    var size: String
    var solid: Bool
    var text: WESceneEntityText
    var verticalalign: String
    var visible: WESceneObjectVisible
}

struct WESceneAudio: WESceneObjectProtocol {
    var angles: String
    var id: Int
    var locktransforms: Bool
    var maxtime: Double
    var mintime: Double
    var muteineditor: Bool
    var name: String
    var origin: String
    var parallaxDepth: String
    var playbackmode: String
    var scale: String
    var sound: [String]
    var startsilent: Bool
    var volume: Double
}

protocol WESceneObjectProtocol: Codable {
    var angles: String { get set }
    var id: Int { get set }
    var locktransforms: Bool { get set }
    var origin: String { get set }
    var parallaxDepth: String { get set }
    var scale: String { get set }
}

enum WESceneObject /*: Codable, Equatable, Hashable*/ {
//    case int(Int)
//    case string(String)
    case audio(WESceneAudio)
    case entity(WESceneEntity)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(WESceneAudio.self) {
            self = .audio(x)
            return
        }
        if let x = try? container.decode(WESceneEntity.self) {
            self = .entity(x)
            return
        }
        throw DecodingError.typeMismatch(Self.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Scene Object"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .audio(let x):
            try container.encode(x)
        case .entity(let x):
            try container.encode(x)
        }
    }
}

struct WEScene: Codable {
    var camera: WESceneCamera
    var general: WESceneGeneral
    var objects: [Int]
    var version: Int
}
