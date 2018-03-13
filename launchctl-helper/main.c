//
//  main.c
//  launchctl-helper
//
//  Created by Adrian Serrano on 13/03/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#include <stdio.h>
#include <unistd.h>

int main(int argc, const char * argv[]) {
    if (setuid(0) != 0) {
        perror("setuid");
        return 1;
    }
    argv[0] = "/bin/launchctl";
    execvp(argv[0], argv);
    perror("execvp");
    return 2;
}
