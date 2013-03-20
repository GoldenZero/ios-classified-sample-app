/*
 * Copyright (C) 2012 SheenFigure
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "SFTypes.h"
#include "SFInternal.h"
#include "SFGSUBData.h"

#ifdef GSUB_SINGLE

static void SFReadSingleSubst(const SFUByte * const ssTable, SingleSubstSubtable *tablePtr) {
    SFUShort substFormat;
    SFUShort coverageOffset;
    
    SFUShort glyphCount;
    
    substFormat = SFReadUShort(ssTable, 0);
    tablePtr->substFormat = substFormat;
    
    coverageOffset = SFReadUShort(ssTable, 2);
    
#ifdef LOOKUP_TEST
    printf("\n      Single Substitution Table:");
    printf("\n       Substitution Format: %d", substFormat);
    printf("\n       Coverage Table Offset: %d", coverageOffset);
    printf("\n       Coverage Table:");
#endif
    
    SFReadCoverageTable(&ssTable[coverageOffset], &tablePtr->coverage);
    
    switch (substFormat) {
            
#ifdef GSUB_SINGLE_FORMAT1
        case 1:
        {
            tablePtr->format.format1.deltaGlyphID = SFReadUShort(ssTable, 4);
            
#ifdef LOOKUP_TEST
            printf("\n       Delta Glyph ID: %d", tablePtr->format.format1.deltaGlyphID);
#endif
        }
            break;
            
#endif
            
#ifdef GSUB_SINGLE_FORMAT2
        case 2:
        {
            SFGlyph *substitutes;
            SFUShort i;
            
            glyphCount = SFReadUShort(ssTable, 4);
            tablePtr->format.format2.glyphCount = glyphCount;
            
#ifdef LOOKUP_TEST
            printf("\n       Total Substitutes: %d", glyphCount);
#endif
            
            substitutes = malloc(sizeof(SFGlyph) * glyphCount);
            for (i = 0; i < glyphCount; i++) {
                substitutes[i] = SFReadUShort(ssTable, 6 + (i * 2));
                
#ifdef LOOKUP_TEST
                printf("\n        Substitute At Index %d: %d", i + 1, substitutes[i]);
#endif
            }
            
            tablePtr->format.format2.substitute = substitutes;
        }
            break;
#endif
    }
}

static void SFFreeSingleSubst(SingleSubstSubtable *tablePtr) {
    SFFreeCoverageTable(&tablePtr->coverage);
    
#ifdef GSUB_SINGLE_FORMAT2
    if (tablePtr->substFormat == 2)
        free(tablePtr->format.format2.substitute);
#endif
}

#endif


#ifdef GSUB_MULTIPLE

static void SFReadMultipleSubst(const SFUByte * const msTable, MultipleSubstSubtable *tablePtr) {
    SFUShort substFormat;
    SFUShort coverageOffset;
    SFUShort sequenceCount;
    SequenceTable *sequenceTables;
    
    SFUShort i;
    
    substFormat = SFReadUShort(msTable, 0);
    tablePtr->substFormat = substFormat;
    
    coverageOffset = SFReadUShort(msTable, 2);
    
#ifdef LOOKUP_TEST
    printf("\n      Multiple Substitution Table:");
    printf("\n       Substitution Format: %d", substFormat);
    printf("\n       Coverage Table:");
    printf("\n        Offset: %d", coverageOffset);
#endif
    
    SFReadCoverageTable(&msTable[coverageOffset], &tablePtr->coverage);
    
    sequenceCount = SFReadUShort(msTable, 4);
    tablePtr->sequenceCount = sequenceCount;
    
#ifdef LOOKUP_TEST
    printf("\n       Total Sequences: %d", sequenceCount);
#endif
    
    sequenceTables = malloc(sizeof(SequenceTable) * sequenceCount);
    
    for (i = 0; i < sequenceCount; i++) {
        SFUShort offset;
        const SFUByte *sqTable;
        
        SFUShort glyphCount;
        SFGlyph *substitutes;
        
		SFUShort j;

        offset = SFReadUShort(msTable, 6 + (i * 2));
        
        sqTable = &msTable[offset];
        glyphCount = SFReadUShort(sqTable, 0);
        
#ifdef LOOKUP_TEST
        printf("\n       Sequence %d:", i + 1);
        printf("\n        Offset: %d", offset);
#endif
        
        sequenceTables[i].glyphCount = glyphCount;
        
        substitutes = malloc(sizeof(SFGlyph) * glyphCount);
        
#ifdef LOOKUP_TEST
        printf("\n        Total Substitutes: %d", glyphCount);
#endif
        
        for (j = 0; j < glyphCount; j++) {
            substitutes[j] = SFReadUShort(sqTable, 2 + (j * 2));
            
#ifdef LOOKUP_TEST
            printf("\n        Substitute At Index %d: %d", j, substitutes[j]);
#endif
        }
        
        sequenceTables[i].substitute = substitutes;
    }
    
    tablePtr->sequence = sequenceTables;
}

static void SFFreeMultipleSubst(MultipleSubstSubtable *tablePtr) {
	int i;

    SFFreeCoverageTable(&tablePtr->coverage);
    
    for (i = 0; i < tablePtr->sequenceCount; i++)
        free(tablePtr->sequence[i].substitute);
    
    free(tablePtr->sequence);
}

#endif


#ifdef GSUB_ALTERNATE

static void SFReadAlternateSubst(const SFUByte * const asTable, AlternateSubstSubtable *tablePtr) {
    SFUShort substFormat;
    SFUShort coverageOffset;
    
    AlternateSetTable *alternateSetTables;
    
    SFUShort i;
    
    substFormat = SFReadUShort(asTable, 0);
    tablePtr->substFormat = substFormat;
    
    coverageOffset = SFReadUShort(asTable, 2);
    
#ifdef LOOKUP_TEST
    printf("\n      Alternate Substitution Table:");
    printf("\n       Substitution Format: %d", substFormat);
    printf("\n       Coverage Table Offset: %d", coverageOffset);
    printf("\n       Coverage Table:");
#endif
    
    SFReadCoverageTable(&asTable[coverageOffset], &tablePtr->coverage);
    
    tablePtr->alternateSetCount = SFReadUShort(asTable, 4);
    
#ifdef LOOKUP_TEST
    printf("\n       Total Alternate Sets: %d", tablePtr->alternateSetCount);
#endif
    
    alternateSetTables = malloc(sizeof(AlternateSetTable) * tablePtr->alternateSetCount);
    
    for (i = 0; i < tablePtr->alternateSetCount; i++) {
        SFUShort offset;
        const SFUByte *aTable;
        
        SFUShort glyphCount;
        SFGlyph *substitutes;
        
        SFUShort j;
        
        offset = SFReadUShort(asTable, 6 + (i * 2));
        
#ifdef LOOKUP_TEST
        printf("\n       Alternate Set %d:", i + 1);
        printf("\n        Offset: %d", offset);
#endif
        
        aTable = &asTable[offset];
        glyphCount = SFReadUShort(aTable, 0);
        
#ifdef LOOKUP_TEST
        printf("\n        Total Alternates: %d", glyphCount);
#endif
        
        substitutes = malloc(sizeof(SFGlyph) * glyphCount);
        
        for (j = 0; j < glyphCount; j++) {
            substitutes[j] = SFReadUShort(aTable, 2 + (j * 2));
            
#ifdef LOOKUP_TEST
            printf("\n        Alternate At Index %d: %d", j, substitutes[j]);
#endif
        }
        
        alternateSetTables[i].substitute = substitutes;
    }
    
    tablePtr->alternateSet = alternateSetTables;
}

static void SFFreeAlternateSubst(AlternateSubstSubtable *tablePtr) {
	int i;

    SFFreeCoverageTable(&tablePtr->coverage);
    
    for (i = 0; i < tablePtr->alternateSetCount; i++)
        free(tablePtr->alternateSet[i].substitute);
    
    free(tablePtr->alternateSet);
}

#endif


#ifdef GSUB_LIGATURE

static void SFReadLigatureSubst(const SFUByte * const lsTable, LigatureSubstSubtable *tablePtr) {
    SFUShort substFormat;
    SFUShort coverageOffset;
    
    SFUShort ligSetCount;
    LigatureSetTable *ligSetTables;
    
    SFUShort i;
    
    substFormat = SFReadUShort(lsTable, 0);
    tablePtr->substFormat = substFormat;
    
    coverageOffset = SFReadUShort(lsTable, 2);
    
#ifdef LOOKUP_TEST
    printf("\n      Ligature Substitution Table:");
    printf("\n       Substitution Format: %d", substFormat);
    printf("\n       Coverage Table:");
    printf("\n        Offset: %d", coverageOffset);
#endif
    
    SFReadCoverageTable(&lsTable[coverageOffset], &tablePtr->coverage);
    
    ligSetCount = SFReadUShort(lsTable, 4);
    tablePtr->ligSetCount = ligSetCount;
    
#ifdef LOOKUP_TEST
    printf("\n       Total Ligature Sets: %d", ligSetCount);
#endif
    
    ligSetTables = malloc(sizeof(LigatureSetTable) * ligSetCount);
    
    for (i = 0; i < ligSetCount; i++) {
        SFUShort offset;
        const SFUByte *ligsTable;
        
        SFUShort ligCount;
        LigatureTable *ligatureTables;
        
        SFUShort j;
        
        offset = SFReadUShort(lsTable, 6 + (i * 2));
        
        ligsTable = &lsTable[offset];
        ligCount = SFReadUShort(ligsTable, 0);
        ligSetTables[i].ligatureCount = ligCount;
        
#ifdef LOOKUP_TEST
        printf("\n       Ligature Set %d:", i + 1);
        printf("\n        Offset: %d", offset);
        printf("\n        Total Ligature Tables: %d", ligCount);
#endif
        
        ligatureTables = malloc(sizeof(LigatureTable) * ligCount);
        
        for (j = 0; j < ligCount; j++) {
            SFUShort ligOffset;
            const SFUByte *lTable;
            
            SFUShort compCount;
            SFGlyph *components;
            
			SFUShort k;

            ligOffset = SFReadUShort(ligsTable, 2 + (j * 2));
            
            lTable = &ligsTable[ligOffset];
            ligatureTables[j].ligGlyph = SFReadUShort(lTable, 0);
            
            compCount = SFReadUShort(lTable, 2);
            ligatureTables[j].compCount = compCount;
            
#ifdef LOOKUP_TEST
            printf("\n        Ligature Table %d:", j + 1);
            printf("\n         Offset: %d", ligOffset);
            printf("\n         Ligature Glyph: %d", ligatureTables[j].ligGlyph);
            printf("\n         Total Components: %d", compCount);
#endif
            
            components = malloc(sizeof(SFGlyph) * compCount);
            components[0] = 0;
            
            for (k = 0; k < compCount - 1; k++) {
                components[k + 1] = SFReadUShort(lTable, 4 + (k * 2));
                
#ifdef LOOKUP_TEST
                printf("\n         Component At Index %d: %d", k + 1, components[k + 1]);
#endif
            }
            
            ligatureTables[j].component = components;
        }
        
        ligSetTables[i].ligature = ligatureTables;
    }
    
    tablePtr->ligatureSet = ligSetTables;
}

static void SFFreeLigatureSubst(LigatureSubstSubtable *tablePtr) {
	int i, j;

    SFFreeCoverageTable(&tablePtr->coverage);
    
    for (i = 0; i < tablePtr->ligSetCount; i++) {
        for (j = 0; j < tablePtr->ligatureSet[i].ligatureCount; j++)
            free(tablePtr->ligatureSet[i].ligature[j].component);
        
        free(tablePtr->ligatureSet[i].ligature);
    }
    
    free(tablePtr->ligatureSet);
}

#endif


#ifdef GSUB_CONTEXT

static void SFReadContextSubst(const SFUByte * const csTable, ContextSubstSubtable *tablePtr) {
    SFUShort substFormat = SFReadUShort(csTable, 0);
    tablePtr->substFormat = substFormat;
    
#ifdef LOOKUP_TEST
    printf("\n      Context Substitution Table:");
    printf("\n       Substitution Format: %d", substFormat);
#endif
    
    switch (substFormat) {
            
#ifdef GSUB_CONTEXT_FORMAT1
        case 1:
        {
            SFUShort coverageOffset;
            SFUShort subRuleSetCount;
            SubRuleSetTable *subRuleSetTables;
            
            SFUShort i;
            
            coverageOffset = SFReadUShort(csTable, 2);
            
#ifdef LOOKUP_TEST
            printf("\n       Coverage Table:");
            printf("\n        Offset: %d", coverageOffset);
#endif
            
            SFReadCoverageTable(&csTable[coverageOffset], &tablePtr->format.format1.coverage);
            
            subRuleSetCount = SFReadUShort(csTable, 4);
            tablePtr->format.format1.subRuleSetCount = subRuleSetCount;
            
#ifdef LOOKUP_TEST
            printf("\n       Total Substitution Rule Sets: %d", subRuleSetCount);
#endif
            
            subRuleSetTables = malloc(sizeof(SubRuleSetTable) * subRuleSetCount);
            
            for (i = 0; i < subRuleSetCount; i++) {
                SFUShort subRuleSetOffset;
                const SFUByte *srsTable;
                
                SFUShort subRuleCount;
                SubRuleTable *subRuleTables;
                SFUShort j;
                
                subRuleSetOffset = SFReadUShort(csTable, 6 + (i * 2));
                srsTable = &csTable[subRuleSetOffset];
                
#ifdef LOOKUP_TEST
                printf("\n       Substitution Rule Set %d:", i + 1);
                printf("\n        Offset: %d", subRuleSetOffset);
#endif
                
                subRuleCount = SFReadUShort(srsTable, 0);
                subRuleSetTables[i].subRuleCount = subRuleCount;
                
#ifdef LOOKUP_TEST
                printf("\n        Total Substitution Rules: %d", subRuleCount);
#endif
                
                subRuleTables = malloc(sizeof(SubRuleTable) * subRuleCount);
                
                for (j = 0; j < subRuleCount; j++) {
                    SFUShort subRuleOffset;
                    const SFUByte *srTable;
                    
                    SFUShort glyphCount;
                    SFUShort substCount;
                    
                    SFGlyph *glyphs;
                    SFUShort k, l;
                    
                    SubstLookupRecord *substLookupRecords;
                    
                    subRuleOffset = SFReadUShort(srsTable, 2 + (j * 2));
                    srTable = &srsTable[subRuleOffset];
                    
#ifdef LOOKUP_TEST
                    printf("\n        Substitution Rule %d:", j + 1);
                    printf("\n         Offset: %d", subRuleOffset);
#endif
                    
                    glyphCount = SFReadUShort(srTable, 0);
                    subRuleTables[j].glyphCount = glyphCount;
                    
                    substCount = SFReadUShort(srTable, 2);
                    subRuleTables[j].substCount = substCount;
                    
#ifdef LOOKUP_TEST
                    printf("\n         Total Input Glyphs: %d", glyphCount);
                    printf("\n         Total Lookup Records: %d", substCount);
#endif
                    
                    glyphs = malloc(sizeof(SFGlyph) * glyphCount);
                    glyphs[0] = 0;
                    
                    for (k = 0; k < glyphCount; k++) {
                        glyphs[k + 1] = SFReadUShort(srTable, 4 + (k * 2));
                        
#ifdef LOOKUP_TEST
                        printf("\n         Input Glyph At Index %d: %d", k, glyphs[k + 1]);
#endif
                    }
                    
                    subRuleTables[j].input = glyphs;
                    
                    k += 4;
                    
                    substLookupRecords = malloc(sizeof(SubstLookupRecord) * substCount);
                    for (l = 0; l < substCount; l++) {
                        SFUShort beginOffset = k + (l * 4);
                        
                        substLookupRecords[l].sequenceIndex = SFReadUShort(srTable, beginOffset);
                        substLookupRecords[l].lookupListIndex = SFReadUShort(srTable, beginOffset + 2);
                        
#ifdef LOOKUP_TEST
                        printf("\n         Lookup Record At Index %d:", l);
                        printf("\n          Sequence Index: %d", substLookupRecords[l].sequenceIndex);
                        printf("\n          Lookup List Index: %d", substLookupRecords[l].lookupListIndex);
#endif
                    }
                    
                    subRuleTables[j].substLookupRecord = substLookupRecords;
                }
                
                subRuleSetTables[i].subRule = subRuleTables;
            }
            
            tablePtr->format.format1.subRuleSet = subRuleSetTables;
        }
            break;
#endif
            
#ifdef GSUB_CONTEXT_FORMAT2
        case 2:
        {
            SFUShort coverageOffset;
            SFUShort classDefOffset;
            SFUShort subClassSetCount;
            SubClassSetSubtable *subRuleSetTables;
            
            SFUShort i;
            
            coverageOffset = SFReadUShort(csTable, 2);
            
#ifdef LOOKUP_TEST
            printf("\n       Coverage Table:");
            printf("\n        Offset: %d", coverageOffset);
#endif
            
            SFReadCoverageTable(&csTable[coverageOffset], &tablePtr->format.format2.coverage);
            
            classDefOffset = SFReadUShort(csTable, 4);
            
#ifdef LOOKUP_TEST
            printf("\n       Class Definition Table:");
            printf("\n        Offset: %d", classDefOffset);
#endif
            
            SFReadClassDefTable(&csTable[classDefOffset], &tablePtr->format.format2.classDef);
            
            subClassSetCount = SFReadUShort(csTable, 6);
            
#ifdef LOOKUP_TEST
            printf("\n       Total Sub Class Sets: %d", subClassSetCount);
#endif
            
            subRuleSetTables = malloc(sizeof(SubClassSetSubtable) * subClassSetCount);
            
            for (i = 0; i < subClassSetCount; i++) {
                SFUShort subClassSetOffset;
                const SFUByte *scsTable;
                
                SFUShort subClassRuleCount;
                SubClassRuleTable *subRuleTables;
                
                SubstLookupRecord *substLookupRecords;
                
                SFUShort j, l;
                
                subClassSetOffset = SFReadUShort(csTable, 8 + (i * 2));
                scsTable = &csTable[subClassSetOffset];
                
#ifdef LOOKUP_TEST
                printf("\n       Sub Class Set %d:", i + 1);
                printf("\n        Offset: %d", subClassSetOffset);
#endif
                
                subClassRuleCount = SFReadUShort(scsTable, 0);
                subRuleSetTables[i].subClassRuleCnt = subClassRuleCount;
                
#ifdef LOOKUP_TEST
                printf("\n        Total Sub Class Rules: %d", subClassRuleCount);
#endif
                
                subRuleTables = malloc(sizeof(SubClassRuleTable) * subClassRuleCount);
                
                for (j = 0; j < subClassRuleCount; j++) {
                    SFUShort subClassRuleOffset;
                    const SFUByte *scrTable;
                    
                    SFUShort glyphCount;
                    SFUShort substCount;
                    
                    SFUShort *classes;
                    SFUShort k;
                    
                    subClassRuleOffset = SFReadUShort(scsTable, 2 + (j * 2));
                    scrTable = &scsTable[subClassRuleOffset];
                    
#ifdef LOOKUP_TEST
                    printf("\n        Sub Class Rule %d:", j + 1);
                    printf("\n         Offset: %d", subClassRuleOffset);
#endif
                    
                    glyphCount = SFReadUShort(scrTable, 0);
                    subRuleTables[j].glyphCount = glyphCount;
                    
                    substCount = SFReadUShort(scrTable, 2);
                    subRuleTables[j].substCount = substCount;
                    
#ifdef LOOKUP_TEST
                    printf("\n         Total Input Glyphs: %d", glyphCount);
                    printf("\n         Total Lookup Records: %d", substCount);
#endif
                    
                    classes = malloc(sizeof(SFUShort) * glyphCount);
                    classes[0] = 0;
                    
                    for (k = 0; k < glyphCount; k++) {
                        classes[k + 1] = SFReadUShort(scrTable, 4 + (k * 2));
                        
#ifdef LOOKUP_TEST
                        printf("\n         Class At Index %d: %d", k + 1, classes[k + 1]);
#endif
                    }
                    
                    subRuleTables[j].cls = classes;
                    
                    k += 4;
                    
                    substLookupRecords = malloc(sizeof(SubstLookupRecord) * substCount);
                    for (l = 0; l < substCount; l++) {
                        SFUShort beginOffset = k + (l * 4);
                        
                        substLookupRecords[l].sequenceIndex = SFReadUShort(scrTable, beginOffset);
                        substLookupRecords[l].lookupListIndex = SFReadUShort(scrTable, beginOffset + 2);
                        
#ifdef LOOKUP_TEST
                        printf("\n         Lookup Record At Index %d:", l);
                        printf("\n          Sequence Index: %d", substLookupRecords[l].sequenceIndex);
                        printf("\n          Lookup List Index: %d", substLookupRecords[l].lookupListIndex);
#endif
                    }
                    
                    subRuleTables[j].substLookupRecord = substLookupRecords;
                }
                
                subRuleSetTables[i].subClassRule = subRuleTables;
            }
            
            tablePtr->format.format2.subClassSet = subRuleSetTables;
        }
            break;
#endif
            
#ifdef GSUB_CONTEXT_FORMAT3
        case 3:
        {
            SFUShort glyphCount;
            SFUShort substCount;
            
            SubstLookupRecord *substLookupRecords;
            
            CoverageTable *coverageTables;
            SFUShort i, j;
            
            glyphCount = SFReadUShort(csTable, 2);
            substCount = SFReadUShort(csTable, 4);
            
#ifdef LOOKUP_TEST
            printf("\n       Total Coverage Tables: %d", glyphCount);
            printf("\n       Total Lookup Records: %d", substCount);
#endif
            
            tablePtr->format.format3.glyphCount = glyphCount;
            tablePtr->format.format3.substCount = substCount;
            
            coverageTables = malloc(sizeof(CoverageTable) * glyphCount);
            
            for (i = 0; i < glyphCount; i++) {
                SFUShort coverageOffset = SFReadUShort(csTable, 6 + (i * 2));
                
#ifdef LOOKUP_TEST
                printf("\n       Coverage Table %d:", i + 1);
                printf("\n        Offset: %d", coverageOffset);
#endif
                
                SFReadCoverageTable(&csTable[coverageOffset], &coverageTables[i]);
            }
            
            tablePtr->format.format3.coverage = coverageTables;
            
            substLookupRecords = malloc(sizeof(SubstLookupRecord) * substCount);
            for (j = 0; j < substCount; j++) {
                SFUShort beginOffset = 8 + (j * 4);
                
                substLookupRecords[j].sequenceIndex = SFReadUShort(csTable, beginOffset);
                substLookupRecords[j].lookupListIndex = SFReadUShort(csTable, beginOffset + 2);
                
#ifdef LOOKUP_TEST
                printf("\n       Lookup Record At Index %d:", j);
                printf("\n        Sequence Index: %d", substLookupRecords[j].sequenceIndex);
                printf("\n        Lookup List Index: %d", substLookupRecords[j].lookupListIndex);
#endif
            }
            
            tablePtr->format.format3.substLookupRecord = substLookupRecords;
        }
            break;
#endif
    }
}

static void SFFreeContextSubst(ContextSubstSubtable *tablePtr) {
	int i, j;

    switch (tablePtr->substFormat) {
#ifdef GSUB_CONTEXT_FORMAT1
        case 1:
        {
            SFFreeCoverageTable(&tablePtr->format.format1.coverage);
            
            for (i = 0; i < tablePtr->format.format1.subRuleSetCount; i++) {
                for (j = 0; j < tablePtr->format.format1.subRuleSet[i].subRuleCount; j++) {
                    free(tablePtr->format.format1.subRuleSet[i].subRule[j].input);
                    free(tablePtr->format.format1.subRuleSet[i].subRule[j].substLookupRecord);
                }
                
                free(tablePtr->format.format1.subRuleSet[i].subRule);
            }
            
            free(tablePtr->format.format1.subRuleSet);
        }
            break;
#endif
            
#ifdef GSUB_CONTEXT_FORMAT2
        case 2:
        {
            
            SFFreeCoverageTable(&tablePtr->format.format2.coverage);
            
            for (i = 0; i < tablePtr->format.format2.subClassSetCnt; i++) {
                for (j = 0; j < tablePtr->format.format2.subClassSet[i].subClassRuleCnt; j++) {
                    free(tablePtr->format.format2.subClassSet[i].subClassRule[j].cls);
                    free(tablePtr->format.format2.subClassSet[i].subClassRule[j].substLookupRecord);
                }
                
                free(tablePtr->format.format2.subClassSet[i].subClassRule);
            }
            
            SFFreeClassDefTable(&tablePtr->format.format2.classDef);
            free(tablePtr->format.format2.subClassSet);
            
        }
            break;
#endif
            
#ifdef GSUB_CONTEXT_FORMAT3
        case 3:
        {
            for (i = 0; i < tablePtr->format.format3.glyphCount; i++)
                SFFreeCoverageTable(&tablePtr->format.format3.coverage[i]);
            
            free(tablePtr->format.format3.coverage);
            free(tablePtr->format.format3.substLookupRecord);
        }
            break;
#endif
    }
}

#endif


#ifdef GSUB_CHAINING_CONTEXT

static void SFReadChainingContextSubst(const SFUByte * const ccsTable, ChainingContextualSubstSubtable *tablePtr) {
    SFUShort substFormat = SFReadUShort(ccsTable, 0);
    tablePtr->substFormat = substFormat;
    
#ifdef LOOKUP_TEST
    printf("\n      Chaining Context Substitution Table:");
    printf("\n       Substitution Format: %d", substFormat);
#endif
    
    switch (substFormat) {
            
#ifdef GSUB_CHAINING_CONTEXT_FORMAT1
        case 1:
        {
            SFUShort coverageOffset;
            SFUShort chainSubRuleSetCount;
            
            ChainSubRuleSetTable *chainSubRuleSetTables;
            
            SFUShort i;
            
            coverageOffset = SFReadUShort(ccsTable, 2);
            
#ifdef LOOKUP_TEST
            printf("\n       Coverage Table:");
            printf("\n        Offset: %d", coverageOffset);
#endif
            SFReadCoverageTable(&ccsTable[coverageOffset], &tablePtr->format.format1.coverage);
            
            chainSubRuleSetCount = SFReadUShort(ccsTable, 4);
            
#ifdef LOOKUP_TEST
            printf("\n       Total Chain Sub Rule Sets: %d", chainSubRuleSetCount);
#endif
            tablePtr->format.format1.chainSubRuleSetCount = chainSubRuleSetCount;
            
            chainSubRuleSetTables = malloc(sizeof(ChainSubRuleSetTable) * chainSubRuleSetCount);
            
            for (i = 0; i < chainSubRuleSetCount; i++) {
                SFUShort chainSubRuleSetOffset;
                const SFUByte *csrsTable;
                
                SFUShort chainSubRuleCount;
                ChainSubRuleSubtable *chainSubRuleTables;
                
                SFUShort j;
                
                chainSubRuleSetOffset = SFReadUShort(ccsTable, 6 + (i * 2));
                csrsTable = &ccsTable[chainSubRuleSetOffset];
                
#ifdef LOOKUP_TEST
                printf("\n       Chain Sub Rule Set %d:", i + 1);
                printf("\n        Offset: %d", chainSubRuleSetOffset);
#endif
                
                chainSubRuleCount = SFReadUShort(csrsTable, 0);
                chainSubRuleSetTables[i].chainSubRuleCount = chainSubRuleCount;
                
#ifdef LOOKUP_TEST
                printf("\n        Total Chain Sub Rule Tables: %d", chainSubRuleCount);
#endif
                
                chainSubRuleTables = malloc(sizeof(ChainSubRuleSubtable) * chainSubRuleCount);
                
                for (j = 0; j < chainSubRuleCount; j++) {
                    SFUShort chainSubRuleOffset;
                    const SFUByte *csrTable;
                    
                    SFUShort backtrackGlyphCount;
                    SFGlyph *backtrackGlyphs;
                    
                    SFUShort inputGlyphCount;
                    SFGlyph *inputGlyphs;
                    
                    SFUShort lookaheadGlyphCount;
                    SFGlyph *lookaheadGlyphs;
                    
                    SFUShort substCount;
                    SubstLookupRecord *substLookupRecords;
                    
                    SFUShort k, l, m, n;
                    
                    chainSubRuleOffset = SFReadUShort(csrsTable, 2 + (j * 2));
                    csrTable = &csrsTable[chainSubRuleOffset];
                    
#ifdef LOOKUP_TEST
                    printf("\n        Chain Sub Rule Table %d:", j + 1);
                    printf("\n         Offset: %d", chainSubRuleOffset);
#endif
                    
                    backtrackGlyphCount = SFReadUShort(csrTable, 0);
                    chainSubRuleTables[j].backtrackGlyphCount = backtrackGlyphCount;
                    
#ifdef LOOKUP_TEST
                    printf("\n         Total Backtrack Glyphs: %d", backtrackGlyphCount);
#endif
                    
                    backtrackGlyphs = malloc(sizeof(SFGlyph) * backtrackGlyphCount);
                    
                    for (k = 0; k < backtrackGlyphCount; k++) {
                        backtrackGlyphs[k] = SFReadUShort(csrTable, 2 + (k * 2));
                        
#ifdef LOOKUP_TEST
                        printf("\n         Backtrack Glyph At Index %d: %d", k, backtrackGlyphs[k]);
#endif
                    }
                    k *= 2;
                    
                    chainSubRuleTables[j].backtrack = backtrackGlyphs;
                    
                    inputGlyphCount = SFReadUShort(csrTable, k);
                    chainSubRuleTables[j].inputGlyphCount = inputGlyphCount;
                    
#ifdef LOOKUP_TEST
                    printf("\n         Total Input Glyphs: %d", inputGlyphCount);
#endif
                    
                    inputGlyphs = malloc(sizeof(SFGlyph) * inputGlyphCount);
                    inputGlyphs[0] = 0;
                    
                    k += 2;
                    for (l = 0; l < inputGlyphCount - 1; l++) {
                        inputGlyphs[l + 1] = SFReadUShort(csrTable, k + (l * 2));
                        
#ifdef LOOKUP_TEST
                        printf("\n         Input Glyph At Index %d: %d", l + 1, inputGlyphs[l + 1]);
#endif
                    }
                    k += l * 2;
                    
                    chainSubRuleTables[j].input = inputGlyphs;
                    
                    lookaheadGlyphCount = SFReadUShort(csrTable, k);
                    chainSubRuleTables[j].lookaheadGlyphCount = lookaheadGlyphCount;
                    
#ifdef LOOKUP_TEST
                    printf("\n         Total Lookahead Glyphs: %d", lookaheadGlyphCount);
#endif
                    
                    lookaheadGlyphs = malloc(sizeof(SFGlyph) * lookaheadGlyphCount);
                    
                    k += 2;
                    for (m = 0; m < lookaheadGlyphCount; m++) {
                        lookaheadGlyphs[m] = SFReadUShort(csrTable, k + (m * 2));
                        
#ifdef LOOKUP_TEST
                        printf("\n         Lookahead Glyph At Index %d: %d", m, inputGlyphs[m]);
#endif
                    }
                    k += m * 2;
                    
                    chainSubRuleTables[j].lookAhead = lookaheadGlyphs;
                    
                    substCount = SFReadUShort(csrTable, k);
                    
#ifdef LOOKUP_TEST
                    printf("\n         Total Substitute Lookup Records: %d", substCount);
#endif
                    
                    substLookupRecords = malloc(sizeof(SubstLookupRecord) * substCount);
                    
                    for (n = 0; n < substCount; l++) {
                        SFUShort beginOffset = k + (n * 4);
                        
                        substLookupRecords[n].sequenceIndex = SFReadUShort(csrTable, beginOffset);
                        substLookupRecords[n].lookupListIndex = SFReadUShort(csrTable, beginOffset + 2);
                        
#ifdef LOOKUP_TEST
                        printf("\n         Lookup Record At Index %d:", n);
                        printf("\n          Sequence Index: %d", substLookupRecords[n].sequenceIndex);
                        printf("\n          Lookup List Index: %d", substLookupRecords[n].lookupListIndex);
#endif
                    }
                    
                    chainSubRuleTables[j].substLookupRecord = substLookupRecords;
                }
                
                chainSubRuleSetTables[i].chainSubRule = chainSubRuleTables;
            }
            
            tablePtr->format.format1.chainSubRuleSet = chainSubRuleSetTables;
        }
            break;
#endif
            
#ifdef GSUB_CHAINING_CONTEXT_FORMAT2
        case 2:
        {
            SFUShort coverageOffset;
            SFUShort backtrackClassDefOffset;
            SFUShort inputClassDefOffset;
            SFUShort lookaheadClassDefOffset;
            
            SFUShort chainSubClassSetCount;
            ChainSubClassSetSubtable *chainSubClassSets;
            
            SFUShort i;
            
            coverageOffset = SFReadUShort(ccsTable, 2);
            
#ifdef LOOKUP_TEST
            printf("\n       Coverage Table:");
            printf("\n        Offset: %d", coverageOffset);
#endif
            
            SFReadCoverageTable(&ccsTable[coverageOffset], &tablePtr->format.format2.coverage);
            
            backtrackClassDefOffset = SFReadUShort(ccsTable, 4);
            
#ifdef LOOKUP_TEST
            printf("\n       Backtrack Class Definition:");
            printf("\n        Offset: %d", backtrackClassDefOffset);
#endif
            
            SFReadClassDefTable(&ccsTable[backtrackClassDefOffset], &tablePtr->format.format2.backtrackClassDef);
            
            inputClassDefOffset = SFReadUShort(ccsTable, 6);
            
#ifdef LOOKUP_TEST
            printf("\n       Input Class Definition:");
            printf("\n        Offset: %d", inputClassDefOffset);
#endif
            
            SFReadClassDefTable(&ccsTable[inputClassDefOffset], &tablePtr->format.format2.inputClassDef);
            
            lookaheadClassDefOffset = SFReadUShort(ccsTable, 8);
            
#ifdef LOOKUP_TEST
            printf("\n       Lookahead Class Definition:");
            printf("\n        Offset: %d", lookaheadClassDefOffset);
#endif
            
            SFReadClassDefTable(&ccsTable[lookaheadClassDefOffset], &tablePtr->format.format2.lookaheadClassDef);
            
            chainSubClassSetCount = SFReadUShort(ccsTable, 10);
            
#ifdef LOOKUP_TEST
            printf("\n       Total Chain Sub Class Sets: %d", chainSubClassSetCount);
#endif
            
            chainSubClassSets = malloc(sizeof(ChainSubClassSetSubtable) * chainSubClassSetCount);
            
            for (i = 0; i < chainSubClassSetCount; i++) {
                SFUShort chainSubClassSetOffset;
                const SFUByte *cscsTable;
                
                SFUShort chainSubClassRuleCount;
                ChainSubClassRuleTable *chainSubClassRuleTables;
                
                SFUShort j;
                
                chainSubClassSetOffset = SFReadUShort(ccsTable, 12 + (i * 2));
                cscsTable = &ccsTable[chainSubClassSetOffset];
                
#ifdef LOOKUP_TEST
                printf("\n       Chain Sub Class Set %d:", i + 1);
                printf("\n        Offset: %d", chainSubClassSetOffset);
#endif
                
                chainSubClassRuleCount = SFReadUShort(cscsTable, 0);
                chainSubClassSets[i].chainSubClassRuleCnt = chainSubClassRuleCount;
                
#ifdef LOOKUP_TEST
                printf("\n        Total Chain Sub Class Rules: %d", chainSubClassRuleCount);
#endif
                
                chainSubClassRuleTables = malloc(sizeof(ChainSubClassRuleTable) * chainSubClassRuleCount);
                
                for (j = 0; j < chainSubClassRuleCount; j++) {
                    SFUShort chainSubClassRuleOffset;
                    const SFUByte *cscrTable;
                    
                    SFUShort backtrackGlyphCount;
                    SFGlyph *backtrackGlyphs;
                    
                    SFUShort inputGlyphCount;
                    SFGlyph *inputGlyphs;
                    
                    SFUShort lookaheadGlyphCount;
                    SFGlyph *lookaheadGlyphs;
                    
                    SFUShort substCount;
                    SubstLookupRecord *substLookupRecords;
                    
                    SFUShort k, l, m, n;
                    
                    chainSubClassRuleOffset = SFReadUShort(cscsTable, 2 + (j * 2));
                    cscrTable = &cscsTable[chainSubClassRuleOffset];
                    
#ifdef LOOKUP_TEST
                    printf("\n        Chain Sub Class Rule %d:", j + 1);
                    printf("\n         Offset: %d", chainSubClassRuleOffset);
#endif
                    
                    backtrackGlyphCount = SFReadUShort(cscrTable, 0);
                    chainSubClassRuleTables[j].backtrackGlyphCount = backtrackGlyphCount;
                    
#ifdef LOOKUP_TEST
                    printf("\n         Total Backtrack Glyphs: %d", backtrackGlyphCount);
#endif
                    
                    backtrackGlyphs = malloc(sizeof(SFGlyph) * backtrackGlyphCount);
                    
                    for (k = 0; k < backtrackGlyphCount; k++) {
                        backtrackGlyphs[k] = SFReadUShort(cscrTable, 2 + (k * 2));
                        
#ifdef LOOKUP_TEST
                        printf("\n         Backtrack Glyph At Index %d: %d", k, backtrackGlyphs[k]);
#endif
                    }
                    k *= 2;
                    
                    chainSubClassRuleTables[j].backtrack = backtrackGlyphs;
                    
                    inputGlyphCount = SFReadUShort(cscrTable, k);
                    chainSubClassRuleTables[j].inputGlyphCount = inputGlyphCount;
                    
#ifdef LOOKUP_TEST
                    printf("\n         Total Input Glyphs: %d", inputGlyphCount);
#endif
                    
                    inputGlyphs = malloc(sizeof(SFGlyph) * inputGlyphCount);
                    inputGlyphs[0] = 0;
                    
                    k += 2;
                    for (l = 0; l < inputGlyphCount - 1; l++) {
                        inputGlyphs[l + 1] = SFReadUShort(cscrTable, k + (l * 2));
                        
#ifdef LOOKUP_TEST
                        printf("\n         Input Glyph At Index %d: %d", l + 1, inputGlyphs[l + 1]);
#endif
                    }
                    k += l * 2;
                    
                    chainSubClassRuleTables[j].input = inputGlyphs;
                    
                    lookaheadGlyphCount = SFReadUShort(cscrTable, k);
                    chainSubClassRuleTables[j].lookaheadGlyphCount = lookaheadGlyphCount;
                    
#ifdef LOOKUP_TEST
                    printf("\n         Total Lookahead Glyphs: %d", lookaheadGlyphCount);
#endif
                    
                    lookaheadGlyphs = malloc(sizeof(SFGlyph) * lookaheadGlyphCount);
                    
                    k += 2;
                    for (m = 0; m < lookaheadGlyphCount; m++) {
                        lookaheadGlyphs[m] = SFReadUShort(cscrTable, k + (m * 2));
                        
#ifdef LOOKUP_TEST
                        printf("\n         Lookahead Glyph At Index %d: %d", m, lookaheadGlyphs[m]);
#endif
                    }
                    k += m * 2;
                    
                    chainSubClassRuleTables[j].lookAhead = lookaheadGlyphs;
                    
                    substCount = SFReadUShort(cscrTable, k);
                    
#ifdef LOOKUP_TEST
                    printf("\n         Total Substitute Lookup Records: %d", substCount);
#endif
                    
                    substLookupRecords = malloc(sizeof(SubstLookupRecord) * substCount);
                    
                    for (n = 0; n < substCount; l++) {
                        SFUShort beginOffset = k + (n * 4);
                        
                        substLookupRecords[n].sequenceIndex = SFReadUShort(cscrTable, beginOffset);
                        substLookupRecords[n].lookupListIndex = SFReadUShort(cscrTable, beginOffset + 2);
                        
#ifdef LOOKUP_TEST
                        printf("\n         Lookup Record At Index %d:", n);
                        printf("\n          Sequence Index: %d", substLookupRecords[n].sequenceIndex);
                        printf("\n          Lookup List Index: %d", substLookupRecords[n].lookupListIndex);
#endif
                    }
                    
                    chainSubClassRuleTables[j].substLookupRecord = substLookupRecords;
                }
                
                chainSubClassSets[i].chainSubClassRule = chainSubClassRuleTables;
            }
            
            tablePtr->format.format2.chainSubClassSet = chainSubClassSets;
        }
            break;
#endif
            
#ifdef GSUB_CHAINING_CONTEXT_FORMAT3
        case 3:
        {
            SFUShort backtrackGlyphCount;
            CoverageTable *backtrackCoverageTables;
            
            SFUShort inputGlyphCount;
            CoverageTable *inputCoverageTables;
            
            SFUShort lookaheadGlyphCount;
            CoverageTable *lookaheadCoverageTables;
            
            SFUShort substCount;
            SubstLookupRecord *substLookupRecords;
            
            SFUShort i, j, k, l;
            
            backtrackGlyphCount = SFReadUShort(ccsTable, 2);
            tablePtr->format.format3.backtrackGlyphCount = backtrackGlyphCount;
            
#ifdef LOOKUP_TEST
            printf("\n       Total Backtrack Glyphs: %d", backtrackGlyphCount);
#endif
            
            backtrackCoverageTables = malloc(sizeof(CoverageTable) * backtrackGlyphCount);
            
            for (i = 0; i < backtrackGlyphCount; i++) {
                SFUShort coverageOffset = SFReadUShort(ccsTable, 4 + (i * 2));
                
#ifdef LOOKUP_TEST
                printf("\n        Backtrack Coverage %d:", i + 1);
                printf("\n         Offset: %d", coverageOffset);
                
#endif
                SFReadCoverageTable(&ccsTable[coverageOffset], &backtrackCoverageTables[i]);
            }
            i = (4 + (i * 2));
            
            tablePtr->format.format3.backtrackGlyphCoverage = backtrackCoverageTables;
            
            inputGlyphCount = SFReadUShort(ccsTable, i);
            tablePtr->format.format3.inputGlyphCount = inputGlyphCount;
            
#ifdef LOOKUP_TEST
            printf("\n       Total Input Glyphs: %d", inputGlyphCount);
#endif
            
            inputCoverageTables = malloc(sizeof(CoverageTable) * inputGlyphCount);
            
            i += 2;
            
            for (j = 0; j < inputGlyphCount; j++) {
                SFUShort coverageOffset = SFReadUShort(ccsTable, i + (j * 2));
                
#ifdef LOOKUP_TEST
                printf("\n        Input Coverage %d:", j);
                printf("\n         Offset: %d", coverageOffset);
#endif
                
                SFReadCoverageTable(&ccsTable[coverageOffset], &inputCoverageTables[j]);
            }
            i += (j * 2);
            
            tablePtr->format.format3.inputGlyphCoverage = inputCoverageTables;
            
            lookaheadGlyphCount = SFReadUShort(ccsTable, i);
            tablePtr->format.format3.lookaheadGlyphCount = lookaheadGlyphCount;
            
#ifdef LOOKUP_TEST
            printf("\n       Total Lookahead Glyphs: %d", lookaheadGlyphCount);
#endif
            
            lookaheadCoverageTables = malloc(sizeof(CoverageTable) * lookaheadGlyphCount);
            
            i += 2;
            
            for (k = 0; k < lookaheadGlyphCount; k++) {
                SFUShort coverageOffset = SFReadUShort(ccsTable, i + (k * 2));
                
#ifdef LOOKUP_TEST
                printf("\n        Lookahead Coverage %d:", k);
                printf("\n         Offset: %d", coverageOffset);
                
#endif
                SFReadCoverageTable(&ccsTable[coverageOffset], &lookaheadCoverageTables[k]);
            }
            i += (k * 2);
            
            tablePtr->format.format3.lookaheadGlyphCoverage = lookaheadCoverageTables;
            
            substCount = SFReadUShort(ccsTable, i);
            tablePtr->format.format3.substCount = substCount;
            
            substLookupRecords = malloc(sizeof(SubstLookupRecord) * substCount);
            
#ifdef LOOKUP_TEST
            printf("\n         Total Substitute Lookup Records: %d", substCount);
#endif
            
            i += 2;
            for (l = 0; l < substCount; l++) {
                SFUShort beginOffset = i + (l * 4);
                
                substLookupRecords[l].sequenceIndex = SFReadUShort(ccsTable, beginOffset);
                substLookupRecords[l].lookupListIndex = SFReadUShort(ccsTable, beginOffset + 2);
                
#ifdef LOOKUP_TEST
                printf("\n         Lookup Record At Index %d:", l);
                printf("\n          Sequence Index: %d", substLookupRecords[l].sequenceIndex);
                printf("\n          Lookup List Index: %d", substLookupRecords[l].lookupListIndex);
#endif
            }
            
            tablePtr->format.format3.SubstLookupRecord = substLookupRecords;
        }
            break;
#endif
    }
}

static void SFFreeChainingContextualSubst(ChainingContextualSubstSubtable *tablePtr) {
	int i, j;

    switch (tablePtr->substFormat) {
            
#ifdef GSUB_CHAINING_CONTEXT_FORMAT1
        case 1:
        {
            SFFreeCoverageTable(&tablePtr->format.format1.coverage);
            
            for (i = 0; i < tablePtr->format.format1.chainSubRuleSetCount; i++) {
                for (j = 0; j < tablePtr->format.format1.chainSubRuleSet[i].chainSubRuleCount; j++) {
                    free(tablePtr->format.format1.chainSubRuleSet[i].chainSubRule[j].backtrack);
                    free(tablePtr->format.format1.chainSubRuleSet[i].chainSubRule[j].input);
                    free(tablePtr->format.format1.chainSubRuleSet[i].chainSubRule[j].lookAhead);
                    free(tablePtr->format.format1.chainSubRuleSet[i].chainSubRule[j].substLookupRecord);
                }
                
                free(tablePtr->format.format1.chainSubRuleSet[i].chainSubRule);
            }
            
            free(tablePtr->format.format1.chainSubRuleSet);
        }
            break;
#endif
            
#ifdef GSUB_CHAINING_CONTEXT_FORMAT2
        case 2:
        {
            SFFreeCoverageTable(&tablePtr->format.format2.coverage);
            
            SFFreeClassDefTable(&tablePtr->format.format2.backtrackClassDef);
            SFFreeClassDefTable(&tablePtr->format.format2.inputClassDef);
            SFFreeClassDefTable(&tablePtr->format.format2.lookaheadClassDef);
            
            for (i = 0; i < tablePtr->format.format2.chainSubClassSetCnt; i++) {
                for (j = 0; j < tablePtr->format.format2.chainSubClassSet[i].chainSubClassRuleCnt; j++) {
                    free(tablePtr->format.format2.chainSubClassSet[i].chainSubClassRule[j].backtrack);
                    free(tablePtr->format.format2.chainSubClassSet[i].chainSubClassRule[j].input);
                    free(tablePtr->format.format2.chainSubClassSet[i].chainSubClassRule[j].lookAhead);
                    free(tablePtr->format.format2.chainSubClassSet[i].chainSubClassRule[j].substLookupRecord);
                }
                
                free(tablePtr->format.format2.chainSubClassSet[i].chainSubClassRule);
            }
            
            free(tablePtr->format.format2.chainSubClassSet);
        }
            break;
#endif
            
#ifdef GSUB_CHAINING_CONTEXT_FORMAT3
        case 3:
        {
            for (i = 0; i < tablePtr->format.format3.backtrackGlyphCount; i++)
                SFFreeCoverageTable(&tablePtr->format.format3.backtrackGlyphCoverage[i]);
            
            free(tablePtr->format.format3.backtrackGlyphCoverage);
            
            for (i = 0; i < tablePtr->format.format3.inputGlyphCount; i++)
                SFFreeCoverageTable(&tablePtr->format.format3.inputGlyphCoverage[i]);
            
            free(tablePtr->format.format3.inputGlyphCoverage);
            
            for (i = 0; i < tablePtr->format.format3.lookaheadGlyphCount; i++)
                SFFreeCoverageTable(&tablePtr->format.format3.lookaheadGlyphCoverage[i]);
            
            free(tablePtr->format.format3.lookaheadGlyphCoverage);
            free(tablePtr->format.format3.SubstLookupRecord);
        }
            break;
#endif
    }
}

#endif


#ifdef GSUB_REVERSE_CHAINING_CONTEXT

static void SFReadReverseChainingContextSubst(const SFUByte * const rccssTable, ReverseChainingContextSubstSubtable *tablePtr) {
    SFUShort coverageOffset;
    SFUShort backtrackGlyphCount;
    CoverageTable *backtrackCoverageTables;
    
    SFUShort lookaheadGlyphCount;
    CoverageTable *lookaheadCoverageTables;
    
    SFUShort glyphCount;
    SFGlyph *substitutes;
    
    SFUShort i, j, k;
    
    coverageOffset = SFReadUShort(rccssTable, 2);
    
#ifdef LOOKUP_TEST
    printf("\n       Coverage Table:");
    printf("\n        Offset: %d", coverageOffset);
#endif
    
    SFReadCoverageTable(&rccssTable[coverageOffset], &tablePtr->Coverage);
    
    backtrackGlyphCount = SFReadUShort(rccssTable, 4);
    tablePtr->backtrackGlyphCount = backtrackGlyphCount;
    
#ifdef LOOKUP_TEST
    printf("\n       Total Backtrack Glyphs: %d", backtrackGlyphCount);
#endif
    
    backtrackCoverageTables = malloc(sizeof(CoverageTable) * backtrackGlyphCount);
    
    for (i = 0; i < backtrackGlyphCount; i++) {
        SFUShort coverageOffset = SFReadUShort(rccssTable, 6 + (i * 2));
        
#ifdef LOOKUP_TEST
        printf("\n       Backtrack Coverage %d:", i + 1);
        printf("\n        Offset: %d", coverageOffset);
#endif
        
        SFReadCoverageTable(&rccssTable[coverageOffset], &backtrackCoverageTables[i]);
    }
    i = i + (6 + (i * 2));
    
    tablePtr->backtrackGlyphCoverage = backtrackCoverageTables;
    
    lookaheadGlyphCount = SFReadUShort(rccssTable, i);
    tablePtr->lookaheadGlyphCount = lookaheadGlyphCount;
    
#ifdef LOOKUP_TEST
    printf("\n       Total Lookahead Glyphs: %d", backtrackGlyphCount);
#endif
    
    lookaheadCoverageTables = malloc(sizeof(CoverageTable) * lookaheadGlyphCount);
    
    i += 2;
    for (j = 0; j < lookaheadGlyphCount; j++) {
        SFUShort coverageOffset = SFReadUShort(rccssTable, i + (j * 2));
        
#ifdef LOOKUP_TEST
        printf("\n       Lookahead Coverage %d:", i + 1);
        printf("\n        Offset: %d", coverageOffset);
#endif
        
        SFReadCoverageTable(&rccssTable[coverageOffset], &lookaheadCoverageTables[j]);
    }
    i = i + (j * 2) + 2;
    
    tablePtr->lookaheadGlyphCoverage = lookaheadCoverageTables;
    
    glyphCount = SFReadUShort(rccssTable, i);
    tablePtr->glyphCount = glyphCount;
    
#ifdef LOOKUP_TEST
    printf("\n       Total Substitute Glyphs: %d", glyphCount);
#endif
    
    substitutes = malloc(sizeof(SFGlyph) * glyphCount);
    
    i += 2;
    for (k = 0; k < glyphCount; k++) {
        substitutes[k] = SFReadUShort(rccssTable, i + (k * 2));
        
#ifdef LOOKUP_TEST
        printf("\n       Substitute At Index %d: %d", k, substitutes[k]);
#endif
    }
    
    tablePtr->substitute = substitutes;
}

static void SFFreeReverseChainingContextSubst(ReverseChainingContextSubstSubtable *tablePtr) {
    int i;
    
    SFFreeCoverageTable(&tablePtr->Coverage);
    
    for (i = 0; i < tablePtr->backtrackGlyphCount; i++)
        SFFreeCoverageTable(&tablePtr->backtrackGlyphCoverage[i]);
    
    free(tablePtr->backtrackGlyphCoverage);
    
    for (i = 0; i < tablePtr->lookaheadGlyphCount; i++)
        SFFreeCoverageTable(&tablePtr->lookaheadGlyphCoverage[i]);
    
    free(tablePtr->lookaheadGlyphCoverage);
    free(tablePtr->substitute);
}

#endif


static void *SFReadSubstitution(const SFUByte * const sTable, LookupType *type) {
    void *subtablePtr = NULL;
    
    if (*type == ltsExtensionSubstitution) {
        SFUInt extensionOffset;
        
        *type = SFReadUShort(sTable, 2);
        extensionOffset = SFReadUInt(sTable, 4);
        
        return SFReadSubstitution(&sTable[extensionOffset], type);
    }
    
    switch (*type) {
            
#ifdef GSUB_SINGLE
        case ltsSingle:
        {
            SingleSubstSubtable *subtable = malloc(sizeof(SingleSubstSubtable));
            SFReadSingleSubst(sTable, subtable);
            subtablePtr = subtable;
            break;
        }
#endif
            
#ifdef GSUB_MULTIPLE
        case ltsMultiple:
        {
            MultipleSubstSubtable *subtable = malloc(sizeof(MultipleSubstSubtable));
            SFReadMultipleSubst(sTable, subtable);
            subtablePtr = subtable;
            break;
        }
#endif
            
#ifdef GSUB_ALTERNATE
        case ltsAlternate:
        {
            AlternateSubstSubtable *subtable = malloc(sizeof(AlternateSubstSubtable));
            SFReadAlternateSubst(sTable, subtable);
            subtablePtr = subtable;
            break;
        }
#endif
            
#ifdef GSUB_LIGATURE
        case ltsLigature:
        {
            LigatureSubstSubtable *subtable = malloc(sizeof(LigatureSubstSubtable));
            SFReadLigatureSubst(sTable, subtable);
            subtablePtr = subtable;
            break;
        }
#endif
            
#ifdef GSUB_CONTEXT
        case ltsContext:
        {
            ContextSubstSubtable *subtable = malloc(sizeof(ContextSubstSubtable));
            SFReadContextSubst(sTable, subtable);
            subtablePtr = subtable;
            break;
        }
#endif
            
#ifdef GSUB_CHAINING_CONTEXT
        case ltsChainingContext:
        {
            ChainingContextualSubstSubtable *subtable = malloc(sizeof(ChainingContextualSubstSubtable));
            SFReadChainingContextSubst(sTable, subtable);
            subtablePtr = subtable;
            break;
        }
#endif
            
#ifdef GSUB_REVERSE_CHAINING_CONTEXT
        case ltsReverseChainingContextSingle:
        {
            ReverseChainingContextSubstSubtable *subtable = malloc(sizeof(ReverseChainingContextSubstSubtable));
            SFReadReverseChainingContextSubst(sTable, subtable);
            subtablePtr = subtable;
            break;
        }
#endif
            
        default:
            //Reserved for future use
            break;
    }
    
    return subtablePtr;
}

static void SFFreeSubstitution(void *tablePtr, LookupType type) {
    switch (type) {
            
#ifdef GSUB_SINGLE
        case ltsSingle:
            SFFreeSingleSubst(tablePtr);
            break;
#endif
            
#ifdef GSUB_MULTIPLE
        case ltsMultiple:
            SFFreeMultipleSubst(tablePtr);
            break;
#endif
            
#ifdef GSUB_ALTERNATE
        case ltsAlternate:
            SFFreeAlternateSubst(tablePtr);
            break;
#endif
            
#ifdef GSUB_LIGATURE
        case ltsLigature:
            SFFreeLigatureSubst(tablePtr);
            break;
#endif
            
#ifdef GSUB_CONTEXT
        case ltsContext:
            SFFreeContextSubst(tablePtr);
            break;
#endif
            
#ifdef GSUB_CHAINING_CONTEXT
        case ltsChainingContext:
            SFFreeChainingContextualSubst(tablePtr);
            break;
#endif
            
#ifdef GSUB_REVERSE_CHAINING_CONTEXT
        case ltsReverseChainingContextSingle:
            SFFreeReverseChainingContextSubst(tablePtr);
            break;
#endif
        default:
            break;
    }
}


void SFReadGSUB(const SFUByte * const table, SFTableGSUB *tablePtr) {
    SFUShort scriptListOffset;
    SFUShort featureListOffset;
    SFUShort lookupListOffset;
    
    tablePtr->version = SFReadUInt(table, 0);
    
    scriptListOffset = SFReadUShort(table, 4);
    
#ifdef SCRIPT_TEST
    printf("\nGSUB Header:");
    printf("\n Header Version: %u", tablePtr->version);
    printf("\n Script List:");
    printf("\n  Offset: %d", scriptListOffset);
#endif
    
    SFReadScriptListTable(&table[scriptListOffset], &tablePtr->scriptList);
    
    featureListOffset = SFReadUShort(table, 6);
    
#ifdef FEATURE_TEST
    printf("\n Feature List:");
    printf("\n  Offset: %d", featureListOffset);
#endif
    
    SFReadFeatureListTable(&table[featureListOffset], &tablePtr->featureList);
    
    lookupListOffset = SFReadUShort(table, 8);
    
#ifdef LOOKUP_TEST
    printf("\n Lookup List:");
    printf("\n  Offset: %d", lookupListOffset);
#endif
    
    SFReadLookupListTable(&table[lookupListOffset], &tablePtr->lookupList, &SFReadSubstitution);
}

void SFFreeGSUB(SFTableGSUB *tablePtr) {
    SFFreeScriptListTable(&tablePtr->scriptList);
    SFFreeFeatureListTable(&tablePtr->featureList);
    SFFreeLookupListTable(&tablePtr->lookupList, &SFFreeSubstitution);
}