set CompilerFlags=-MTd -nologo -EHa- -Od -Oi -W4 -FC -Z7 -I"C:\lib\SDL2-2.30.11\include" -I"C:\lib\SDL2_ttf-2.24.0\include" -I"C:\lib\SDL2_image-2.8.4\include"
REM -WX - errors as warnings

set LinkerFlags=/LIBPATH:"C:\lib\SDL2-2.30.11\lib\x64" /LIBPATH:"C:\lib\SDL2_ttf-2.24.0\lib\x64" /LIBPATH:"C:\lib\SDL2_image-2.8.4\lib\x64" SDL2.lib SDL2main.lib SDL2_ttf.lib SDL2_image.lib

IF NOT EXIST bin mkdir bin
pushd bin

del *.pdb > NUL 2> NUL
del *.rdi > NUL 2> NUL

cl.exe %CompilerFlags% ..\src\main.c ..\src\render.c ..\src\entity.c ..\src\ecs.c ..\src\utils.c ..\src\engine.c ..\src\asset-store.c /link %LinkerFlags% /OUT:guy.exe 
REM -LD - create dynamic lib

popd

REM clang -g -std=c99 -Wall -Wextra -pedantic -Wmissing-declarations -fsanitize=address -fno-common -fno-omit-frame-pointer src\main.c src\render.c src\entity.c src\ecs.c src\utils.c src\engine.c src\asset-store.c -o bin\guy.exe -IC:\lib\SDL2-2.30.11\include -IC:\lib\SDL2_image-2.8.4\include -LC:\lib\SDL2-2.30.11\lib\x64 -LC:\lib\SDL2_image-2.8.4\lib\x64 -lSDL2 -lSDL2_image
