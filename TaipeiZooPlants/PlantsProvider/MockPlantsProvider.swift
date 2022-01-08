//
//  MockPlantsProvider.swift
//  TaipeiZooPlants
//
//  Created by Arthur Kao on 2022/1/8.
//

import Foundation

class MockPlantsProvider {
    
    typealias Plant = OpenDataPlantsProvider.Plant
    
    private let sampleDatas = [
        Plant(
            name: "九芎",
            location: "臺灣動物區；蟲蟲探索谷；熱帶雨林區；鳥園；兩棲爬蟲動物館",
            feature: "紅褐色的樹皮剝落後呈灰白色，樹幹光滑堅硬。葉有極短的柄，長橢圓形或卵形，全綠，葉片兩端尖，秋冬轉紅。夏季6～8月開花，花冠白色，花數甚多而密生於枝端，花為圓錐花序頂生，花瓣有長柄，邊緣皺曲像衣裙的花邊花絲長短不一。果實為蒴果，橢圓形約6-8公厘，種子有翅。",
            pic: "http://www.zoo.gov.tw/iTAP/04_Plant/Lythraceae/subcostata/subcostata_1.jpg"
        ),
        Plant(
            name: "大安水蓑衣",
            location: "蟲蟲探索谷；水生植物園；白手長臂猿島",
            feature: "水生草本植物。莖直立呈方形，全株多毛。葉長度9公分，寬度1公分，呈披針形或橢圓形，質感類似紙張，雙面皆有白色粗毛。花呈淡紫色，集中開在葉柄與莖的接合處，花朵有上下兩片花瓣類似嘴唇，上唇較小，下唇較大，雄蕊有4枚，兩長兩短。果實呈細長圓柱狀。",
            pic: "http://www.zoo.gov.tw/iTAP/04_Plant/Acanthaceae/pogonocalyx/pogonocalyx_1.jpg"
        ),
        Plant(
            name: "大花紫薇",
            location: "臺灣動物區；蟲蟲探索谷；兒童動物區；熱帶雨林區；白手長臂猿島",
            feature: "落葉喬木，可高達25公尺，樹幹通直，樹皮光滑，呈片狀剝落。單葉對生，革質，葉呈長橢圓形，長度10~28公分，寬度5~12公分，脫落前會變紅。花朵直徑5~8公分，花瓣有6枚，長度2.5~3.5公分，接近圓形，邊緣呈不規則波浪狀，早上初開時呈紅色，傍晚轉為紫紅色。果實直徑約3.5公分，呈球形，分裂成6瓣，初生時呈綠色，成熟時轉褐色。種子扁平具有翅，有利隨風散播。",
            pic: "http://www.zoo.gov.tw/iTAP/04_Plant/Lythraceae/speciosa/speciosa_1.jpg"
        )
    ]
     
    func fetchPlants(limit: Int, offset: Int) async throws -> [Plant] {
        (0..<limit).reduce(into: [Plant]()) { [sampleDatas] result, _ in
            guard let data = sampleDatas.randomElement() else { return }
            result.append(data)
        }
    }
}
