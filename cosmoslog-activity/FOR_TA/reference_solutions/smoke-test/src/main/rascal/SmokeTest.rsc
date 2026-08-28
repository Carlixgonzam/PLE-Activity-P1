module SmokeTest

// Regression check for the reference grammar. Run this any time you
// touch CosmosSyntax.rsc in this folder, or want to confirm a given
// Rascal jar behaves the way the activity assumes it does.
//
// Run it with:
//   java -jar rascal-shell-stable.jar SmokeTest
// from inside this smoke-test directory.

import CosmosSyntax;
import ParseTree;
import IO;

map[str, bool] expected = (
    "mission2_examples.cosmos": true,
    "mission5/E1.cosmos": true,
    "mission5/E2.cosmos": true,
    "mission5/E3.cosmos": false,
    "mission5/E4.cosmos": false,
    "mission5/E5.cosmos": false,
    "mission5/E6.cosmos": true
);

bool accepts(loc file) {
    str text = readFile(file);
    try {
        parse(#start[MissionControlLog], text);
        return true;
    } catch value _: {
        return false;
    }
}

void main(list[str] args) {
    int failures = 0;
    for (name <- expected) {
        loc file = |project://cosmoslogsmoketest/src/main/rascal/instance/<name>|;
        bool actual = accepts(file);
        bool ok = actual == expected[name];
        if (!ok) failures += 1;
        str status = ok ? "pass" : "FAIL";
        str actualLabel = actual ? "accepted" : "rejected";
        println("<status>  <name>  got <actualLabel>");
    }
    if (failures == 0) {
        println("All cases matched the expected result.");
    } else {
        println("<failures> case<failures == 1 ? "" : "s"> did not match. Check the grammar or the expectations above.");
    }
}
