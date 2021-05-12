//
//
//  CTTelephonyNetworkInfo.swift
//  PhobosSwiftCore
//
//  Copyright (c) 2021 Restless Codes Team (https://github.com/restlesscode/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import CoreTelephony

public extension CTTelephonyNetworkInfo {
    
    /// 获取当前sim卡的CTCarrier
    /// 目前逻辑如下，单卡手机只返回单卡信息，双卡手机返回双卡，没有插卡则该数据为空数组
    /// - Returns: CTCarrier 数组
    static func current() -> [CTCarrier] {
        let netWorkInfo = CTTelephonyNetworkInfo()
        var carriers = [CTCarrier]()
        if #available(iOS 12.0, *) {
            carriers =  netWorkInfo.serviceSubscriberCellularProviders?.map {
                $0.value
            } ?? carriers
        } else {
            if let carrier = netWorkInfo.subscriberCellularProvider {
                carriers.append(carrier)
            }
        }
        return carriers
    }
    
    
    /// 返回目前sim的所有country code
    /// - Returns: 返回iSO country code 数组
    static func iSOCountryCode() -> [String] {
        
        return Self.current().compactMap {
            $0.isoCountryCode
        }
    }
    
    
    /// 返回当前手机的所属iso country code
    /// 1、如果插卡返回当前卡的country code
    /// 2、如果没插卡，则根据系统设置local返回country code
    /// - Returns:
    static func pbs_locale() -> [String] {
        var localeCode = iSOCountryCode()
        if localeCode.isEmpty {
            let locale = Locale.current
            if let region = locale.regionCode {
                localeCode.append(region)
            }
        }
        return localeCode
    }
}

public enum MCCType: String {
    case CN = "460" //China
    case AT = "232" //Austria
    case BE = "206" //Belgium
    case BG = "284" //Bulgaria
    case CY = "280" //Cyprus
    case HR = "219" //Croatia
    case CZ = "230" //CzechRepublic
    case DK = "238" //Denmark
    case EE = "248" //Estonia
    case FI = "244" //Finland
    case FR = "208" //France
    case DE = "262" //Germany
    case GR = "202" //Greece
    case HU = "216" //Hungary
    case IE = "272" //Ireland
    case IT = "222" //Italy
    case LV = "247" //Latvia
    case LT = "246" //Lithuania
    case LU = "270" //Luxembourg
    case MT = "278" //Malta
    case NL = "204" //Netherlands
    case PL = "260" //Poland
    case PT = "268" //Portugal
    case RO = "226" //Romania
    case SK = "231" //Slovakia
    case SI = "293" //Slovenia
    case ES = "214" //Spain
    case SE = "240" //Sweden
    case GB_0 = "234" //United Kingdom
    case GB_1 = "235" //United Kingdom
    case RU = "250" //Russian Federation
    case BY = "257" //Belarus
    case UA = "255" //Ukraine
    case VN = "452" //Vietnam
    case LA = "457" //Laos
    case KH = "456" //Cambodia
    case TH = "520" //Thailand
    case MM = "414" //Myanmar
    case MY = "502" //Malaysia
    case SG = "525" //Singapore
    case ID = "510" //Indonesia
    case BN = "528" //Brunei
    case PH = "515" //Philippines
    case TL = "514" //East Timor
    case IN_0 = "404" //India
    case IN_1 = "405" //India
    case TW = "466" //Taiwan
    case US_0 = "310" //United States
    case US_1 = "311" //United States
}

public enum LOCALE: String {
    case AC = "AC" // AC: 阿森松岛
    case AD = "AD" // AD: 安道尔
    case AE = "AE" // AE: 阿拉伯联合酋长国
    case AF = "AF" // AF: 阿富汗
    case AG = "AG" // AG: 安提瓜和巴布达
    case AI = "AI" // AI: 安圭拉
    case AL = "AL" // AL: 阿尔巴尼亚
    case AM = "AM" // AM: 亚美尼亚
    case AO = "AO" // AO: 安哥拉
    case AQ = "AQ" // AQ: 南极洲
    case AR = "AR" // AR: 阿根廷
    case AS = "AS" // AS: 美属萨摩亚
    case AT = "AT" // AT: 奥地利
    case AU = "AU" // AU: 澳大利亚
    case AW = "AW" // AW: 阿鲁巴
    case AX = "AX" // AX: 奥兰群岛
    case AZ = "AZ" // AZ: 阿塞拜疆
    case BA = "BA" // BA: 波斯尼亚和黑塞哥维那
    case BB = "BB" // BB: 巴巴多斯
    case BD = "BD" // BD: 孟加拉国
    case BE = "BE" // BE: 比利时
    case BF = "BF" // BF: 布基纳法索
    case BG = "BG" // BG: 保加利亚
    case BH = "BH" // BH: 巴林
    case BI = "BI" // BI: 布隆迪
    case BJ = "BJ" // BJ: 贝宁
    case BL = "BL" // BL: 圣巴泰勒米
    case BM = "BM" // BM: 百慕大
    case BN = "BN" // BN: 文莱
    case BO = "BO" // BO: 玻利维亚
    case BQ = "BQ" // BQ: 荷属加勒比区
    case BR = "BR" // BR: 巴西
    case BS = "BS" // BS: 巴哈马
    case BT = "BT" // BT: 不丹
    case BV = "BV" // BV: 布韦岛
    case BW = "BW" // BW: 博茨瓦纳
    case BY = "BY" // BY: 白俄罗斯
    case BZ = "BZ" // BZ: 伯利兹
    case CA = "CA" // CA: 加拿大
    case CC = "CC" // CC: 科科斯（基林）群岛
    case CD = "CD" // CD: 刚果（金）
    case CF = "CF" // CF: 中非共和国
    case CG = "CG" // CG: 刚果（布）
    case CH = "CH" // CH: 瑞士
    case CI = "CI" // CI: 科特迪瓦
    case CK = "CK" // CK: 库克群岛
    case CN = "CN" // CN: 中国
    
    case GU = "GU" // GU: 关岛
    case GW = "GW" // GW: 几内亚比绍
    case GY = "GY" // GY: 圭亚那
    case HK = "HK" // HK: 香港（中国）
    case HM = "HM" // HM: 赫德岛和麦克唐纳群岛
    case HN = "HN" // HN: 洪都拉斯
    case HR = "HR" // HR: 克罗地亚
    case HT = "HT" // HT: 海地
    case HU = "HU" // HU: 匈牙利
    case IC = "IC" // IC: 加纳利群岛
    case ID = "ID" // ID: 印度尼西亚
    case IE = "IE" // IE: 爱尔兰
    case IL = "IL" // IL: 以色列
    case IM = "IM" // IM: 马恩岛
    case IN = "IN" // IN: 印度
    case IO = "IO" // IO: 英属印度洋领地
    case IQ = "IQ" // IQ: 伊拉克
    case IR = "IR" // IR: 伊朗
    case IS = "IS" // IS: 冰岛
    case IT = "IT" // IT: 意大利
    case JE = "JE" // JE: 泽西岛
    case JM = "JM" // JM: 牙买加
    case JO = "JO" // JO: 约旦
    case JP = "JP" // JP: 日本
    case KE = "KE" // KE: 肯尼亚
    case KG = "KG" // KG: 吉尔吉斯斯坦
    case KH = "KH" // KH: 柬埔寨
    case KI = "KI" // KI: 基里巴斯
    case KM = "KM" // KM: 科摩罗
    case KN = "KN" // KN: 圣基茨和尼维斯
    case KP = "KP" // KP: 朝鲜
    case KR = "KR" // KR: 韩国
    case KW = "KW" // KW: 科威特
    case KY = "KY" // KY: 开曼群岛
    case KZ = "KZ" // KZ: 哈萨克斯坦
    case LA = "LA" // LA: 老挝
    case LB = "LB" // LB: 黎巴嫩
    case LC = "LC" // LC: 圣卢西亚
    case LI = "LI" // LI: 列支敦士登
    case LK = "LK" // LK: 斯里兰卡
    case LR = "LR" // LR: 利比里亚
    case LS = "LS" // LS: 莱索托
    case LT = "LT" // LT: 立陶宛
    case LU = "LU" // LU: 卢森堡
    case LV = "LV" // LV: 拉脱维亚
    case LY = "LY" // LY: 利比亚
    
    case MX = "MX" // MX: 墨西哥
    case MY = "MY" // MY: 马来西亚
    case MO = "MO" // MO: 澳门
    case MZ = "MZ" // MZ: 莫桑比克
    case NA = "NA" // NA: 纳米比亚
    case NC = "NC" // NC: 新喀里多尼亚
    case NE = "NE" // NE: 尼日尔
    case NF = "NF" // NF: 诺福克岛
    case NG = "NG" // NG: 尼日利亚
    case NI = "NI" // NI: 尼加拉瓜
    case NL = "NL" // NL: 荷兰
    case NO = "NO" // NO: 挪威
    case NP = "NP" // NP: 尼泊尔
    case NR = "NR" // NR: 瑙鲁
    case NU = "NU" // NU: 纽埃
    case NZ = "NZ" // NZ: 新西兰
    case OM = "OM" // OM: 阿曼
    case PA = "PA" // PA: 巴拿马
    case PE = "PE" // PE: 秘鲁
    case PF = "PF" // PF: 法属波利尼西亚
    case PG = "PG" // PG: 巴布亚新几内亚
    case PH = "PH" // PH: 菲律宾
    case PK = "PK" // PK: 巴基斯坦
    case PL = "PL" // PL: 波兰
    case PM = "PM" // PM: 圣皮埃尔和密克隆群岛
    case PN = "PN" // PN: 皮特凯恩群岛
    case PR = "PR" // PR: 波多黎各
    case PS = "PS" // PS: 巴勒斯坦领土
    case PT = "PT" // PT: 葡萄牙
    
    case PW = "PW" // PW: 帕劳
    case PY = "PY" // PY: 巴拉圭
    case QA = "QA" // QA: 卡塔尔
    case RE = "RE" // RE: 留尼汪
    case RO = "RO" // RO: 罗马尼亚
    case RS = "RS" // RS: 塞尔维亚
    case RU = "RU" // RU: 俄罗斯
    case RW = "RW" // RW: 卢旺达
    case SA = "SA" // SA: 沙特阿拉伯
    case SB = "SB" // SB: 所罗门群岛
    case SC = "SC" // SC: 塞舌尔
    case SD = "SD" // SD: 苏丹
    case SE = "SE" // SE: 瑞典
    case SG = "SG" // SG: 新加坡
    case SH = "SH" // SH: 圣赫勒拿
    case SI = "SI" // SI: 斯洛文尼亚
    case SJ = "SJ" // SJ: 斯瓦尔巴和扬马延
    case SK = "SK" // SK: 斯洛伐克
    case SL = "SL" // SL: 塞拉利昂
    case SM = "SM" // SM: 圣马力诺
    case SN = "SN" // SN: 塞内加尔
    case SO = "SO" // SO: 索马里
    case SR = "SR" // SR: 苏里南
    case SS = "SS" // SS: 南苏丹
    case ST = "ST" // ST: 圣多美和普林西比
    case SV = "SV" // SV: 萨尔瓦多
    case SX = "SX" // SX: 荷属圣马丁
    case SY = "SY" // SY: 叙利亚
    case SZ = "SZ" // SZ: 斯威士兰
    case TA = "TA" // TA: 特里斯坦-达库尼亚群岛
    case TC = "TC" // TC: 特克斯和凯科斯群岛
    case TD = "TD" // TD: 乍得
    case TF = "TF" // TF: 法属南部领地
    case TG = "TG" // TG: 多哥
    case TH = "TH" // TH: 泰国
    case TJ = "TJ" // TJ: 塔吉克斯坦
    case TK = "TK" // TK: 托克劳
    case TL = "TL" // TL: 东帝汶
    case TM = "TM" // TM: 土库曼斯坦
    case TN = "TN" // TN: 突尼斯
    case TO = "TO" // TO: 汤加
    case TR = "TR" // TR: 土耳其
    case TT = "TT" // TT: 特立尼达和多巴哥
    case TV = "TV" // TV: 图瓦卢
    case TW = "TW" // TW: 台湾
    case TZ = "TZ" // TZ: 坦桑尼亚
    
    case UM = "UM" // UM: 美国本土外小岛屿
    case US = "US" // US: 美国
    case UY = "UY" // UY: 乌拉圭
    case UZ = "UZ" // UZ: 乌兹别克斯坦
    case VA = "VA" // VA: 梵蒂冈
    case VC = "VC" // VC: 圣文森特和格林纳丁斯
    case VE = "VE" // VE: 委内瑞拉
    case VG = "VG" // VG: 英属维尔京群岛
    case VI = "VI" // VI: 美属维尔京群岛
    case VN = "VN" // VN: 越南
    case VU = "VU" // VU: 瓦努阿图
    case WF = "WF" // WF: 瓦利斯和富图纳
    case WS = "WS" // WS: 萨摩亚
    case XK = "XK" // XK: 科索沃
    case YE = "YE" // YE: 也门
    case YT = "YT" // YT: 马约特
    case ZA = "ZA" // ZA: 南非
    case ZM = "ZM" // ZM: 赞比亚
    case ZW = "ZW" // ZW: 津巴布韦
}
