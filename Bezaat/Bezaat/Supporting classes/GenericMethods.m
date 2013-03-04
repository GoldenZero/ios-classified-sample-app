//
//  GenericMethods.m
//  Bezaat
//
//  Created by Roula Misrabi on 3/4/13.
//  Copyright (c) 2013 Syrisoft. All rights reserved.
//

#import "GenericMethods.h"

@implementation GenericMethods

+ (NSString *) countryName: (enum Country) theCountry {
    
    switch (theCountry) {
        case SaudiArabia: return SAUDI_ARABIA_NAME;
            break;
            
        case Emirates: return EMIRATES_NAME;
            break;
            
        case Kuwait: return KUWAIT_NAME;
            break;
        
        case Qatar: return QATAR_NAME;
            break;
        
        case Bahrain: return BAHRAIN_NAME;
            break;
        
        case Yemen: return YEMEN_NAME;
            break;
        
        case Iraq: return IRAQ_NAME;
            break;
        
        case Syria: return SYRIA_NAME;
            break;
        
        case Jordan: return JORDAN_NAME;
            break;
        
        case Lebanon: return LEBANON_NAME;
            break;
        
        case Egypt: return EGYPT_NAME;
            break;
        
        case Algeria: return ALGERIA_NAME;
            break;
        
        case Tunisia: return TUNISIA_NAME;
            break;
        
        case Sudan: return SUDAN_NAME;
            break;
        
        case Morocco: return MOROCCO_NAME;
            break;
        
        case Libya: return LIBYA_NAME;
            break;
        
        case Somalia: return SOMALIA_NAME;
            break;
        
        case Mauritania: return MAURITANIA_NAME;
            break;
        
        case Djibouti: return DJIBOUTI_NAME;
            break;
        
        case Comoros: return COMOROS_NAME;
            break;
        
        case Oman: return OMAN_NAME;
            break;
            
        case Palestine: return PALESTINE_NAME;
            break;
            
        default: return @"";
            break;
    }
}

+(NSString*) SaudiArabiaCityName:(enum SaudiArabiaCities)  theCity {
    switch (theCity) {
        case _Riyadh:
            return RIYADH_CITY_NAME;
            break;
            
        default: return @"";
            break;
    }
}

+(NSString*) EmiratesCityName:(enum EmiratesCities)  theCity {
    switch (theCity) {
        case _AbuDhabi:
            return ABUDHABI_CITY_NAME;
            break;
            
        default: return @"";
            break;
    }
}

+(NSString*) KuwaitCityName:(enum KuwaitCities)  theCity {
    switch (theCity) {
        case _Kuwait:
            return KUWAIT_CITY_NAME;
            break;
            
        default: return @"";
            break;
    }
}

/*
+(NSString*) QatarCityName:(enum QatarCities)
+(NSString*) BahrainCityName:(enum BahrainCities)
+(NSString*) YemenCityName:(enum YemenCities)
+(NSString*) IraqCityName:(enum IraqCities)
+(NSString*) SyriaCityName:(enum SyriaCities)
+(NSString*) JordanCityName:(enum JordanCities)
+(NSString*) LebanonCityName:(enum LebanonCities)
+(NSString*) EgyptCityName:(enum EgyptCities)
+(NSString*) AlgeriaCityName:(enum AlgeriaCities)
+(NSString*) TunisiaCityName:(enum TunisiaCities)
+(NSString*) SudanCityName:(enum SudanCities)
+(NSString*) MoroccoCityName:(enum MoroccoCities)
+(NSString*) LibyaCityName:(enum LibyaCities)
+(NSString*) SomaliaCityName:(enum SomaliaCities)
+(NSString*) MauritaniaCityName:(enum MauritaniaCities)
+(NSString*) DjiboutiCityName:(enum DjiboutiCities)
+(NSString*) ComorosCityName:(enum ComorosCities)
+(NSString*) OmanCityName:(enum OmanCities)
+(NSString*) PalestineCityName:(enum PalestineCities)
*/

@end
