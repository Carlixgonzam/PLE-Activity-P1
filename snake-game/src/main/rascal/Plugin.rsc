module Plugin

import IO;
import ParseTree;
import util::Reflective;
import util::IDEServices;
import util::LanguageServer;
import LevelSyntax;

// Registers the level DSL for .snake files, so VS Code shows syntax
// highlighting and live parse errors on level files. This is what makes
// the opening demo work: break a wall line, see the red squiggle, fix
// it, see it go away, no restart needed. It follows the same pattern as
// Plugin.rsc in cosmoslog-dsl, which in turn follows Section 4.2 of the
// tutorial.
//
// Run this file's main function once, in a new Rascal terminal, before
// the session. Level files stay live after that, this only needs to run
// again if the grammar itself changes.

PathConfig pcfg = getProjectPathConfig(|project://snakegame|);
Language snakeLevelLang = language(pcfg, "SnakeLevel", "snake", "Plugin", "contribs");

set[LanguageService] contribs() = {
    parser(start[Level] (str program, loc src) {
        return parse(#start[Level], program, src);
    })
};

void main() {
    registerLanguage(snakeLevelLang);
}
