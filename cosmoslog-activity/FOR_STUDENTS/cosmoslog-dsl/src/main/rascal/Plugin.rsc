module Plugin

import IO;
import ParseTree;
import util::Reflective;
import util::IDEServices;
import util::LanguageServer;
import Relation;
import CosmosSyntax;

// This file is not part of the grammar exercise. It registers
// the CosmosLog DSL for .cosmos files, the same way Plugin.rsc
// does for Planning and Task in Section 4.2 of the tutorial.
// Leave it alone unless your TA tells you otherwise.
//
// It will not compile until you finish start syntax
// MissionControlLog in CosmosSyntax.rsc during Mission 4. That
// failure is expected.

PathConfig pcfg = getProjectPathConfig(|project://cosmoslogdsl|);
Language cosmosLang = language(pcfg, "CosmosLog", "cosmos", "Plugin", "contribs");

set[LanguageService] contribs() = {
    parser(start[MissionControlLog] (str program, loc src) {
        return parse(#start[MissionControlLog], program, src);
    })
};

void main() {
    registerLanguage(cosmosLang);
}
