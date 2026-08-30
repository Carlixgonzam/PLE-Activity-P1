module Plugin

import IO;
import ParseTree;
import util::Reflective;
import util::IDEServices;
import util::LanguageServer;
import Relation;
import F1SeasonSyntax;

// This file is not part of the grammar exercise. It registers
// the F1SeasonSyntax DSL for .f1season files, the same way Plugin.rsc
// does for Planning and Task in Section 4.2 of the tutorial.
// Leave it alone unless your TA tells you otherwise.
//
// It will not compile until you finish start syntax
// F1SeasonRecord in F1SeasonSyntax.rsc during Mission 4. That
// failure is expected.

PathConfig pcfg = getProjectPathConfig(|project://f1seasondsl|);
Language f1SeasonLang = language(pcfg, "F1SeasonSyntax", "f1season", "Plugin", "contribs");

set[LanguageService] contribs() = {
    parser(start[F1SeasonRecord] (str program, loc src) {
        return parse(#start[F1SeasonRecord], program, src);
    })
};


void main() {
    registerLanguage(f1SeasonLang);
}
