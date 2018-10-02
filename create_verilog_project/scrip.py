import os
import io
import sys
import shutil

directory = ["core", "testbench", "script", "project"]
files = { 
            directory[0] : ["tar_controller", 
                            "core_logic", 
                            "top_module", 
                            "led",
                            "buttons"],
            directory[1] : ["tar_controller_tb", 
                            "core_logic_tb", 
                            "top_module_tb", 
                            "led_tb",
                            "buttons_tb"],
            directory[2] : ["Makefile", 
                            "modelsim_script.tcl"],
            directory[3] : ["tar_controller.qpf",
                            "tar_controller.qsf"]
        }
args =  {
            '--init'   : 'Создать проект',
            '--start'  : 'Запустить функциональную модель',
            '--update' : 'Обновить функциональную модуль',
            '--clear'  : 'Удалить проект'
        }

def runFunctionModel():
    pass

def updateModel():
    pass

def clearProject():
    
    # Удаление
    for disc in directory:
        if os.path.exists(disc):
            shutil.rmtree(disc)
            print ("Папка %s удалена" % disc)
        else:
            print ("Папки %s нет в дирректроии" % disc)
            sys.exit (1)

def createFolderFile(): 

    # Проверка
    for disc in directory:
        if os.path.exists(disc):
            print ("Проект уже создан")
            sys.exit (1)

    # Создаем дирректроии   
    print ("Созадние проекта")
    for dirc in directory:
        try:
            if os.path.exists(dirc):
                shutil.rmtree(dirc)
                os.mkdir(dirc)
            else:
                os.mkdir(dirc)
        except OSError:
            print ("Создать директорию %s не удалось" % dirc)
        else:
            print ("Директория %s создана" % dirc)

    # Создаем файлы
    for dirc, file in files.items():

        for item in file:
            if (dirc == directory[0] or dirc == directory[1]):
                tar = open(dirc + '/' + item + '.v', 'w')
            else:
                tar = open(dirc + '/' + item, 'w')
            tar.close()

    # Добавляем шаблон для Verilog файлов
    templateVerilogFile()
    # Добавляем шаблон для работы с Icarus Verilog
    templateMakefileFile()
    # Добавляем шаблон для работы с Modelsim
    templateTclFile()

def templateVerilogFile():

    for dirc, file in files.items():
        if (dirc ==  directory[0]):
            for item in file:
                tar = open(dirc + '/' + item + '.v', 'w')
                tar.write("module " + item + "\n#(\n    parameter DEFAULT = 32\n)\n("
                      + "\n     input                   clk"
                      + "\n,    input                   rst"
                      + "\n,    input   [DEFAULT - 1:0] data_in"
                      + "\n,    output  [DEFAULT - 1:0] data_out"
                      + "\n);"
                      + "\n\nalways @(posedge clk) begin"
                      + "\n if ( rst ) begin\n      \n  end else begin\n        \n  end"
                      + "\nend\n\nendmodule")
                tar.close()
        elif (dirc ==  directory[1]):
            for item in file:
                tar = open(dirc + '/' + item + '.v', 'w')
                tar.write("`timescale 1 ns / 1 ns\nmodule " + item 
                    + "\n#(\n   parameter DEFAULT = 32\n);"
                    + "\n\nreg clk, rst;"
                    + "\n\n" + item.replace("_tb", "") + " #("
                    + "\n   .DEFAULT( DEFAULT ) "
                    + "\n) " + item.replace("_tb", "_sample")
                    + "\n( .clk(clk)\n, .rst(rst)\n);"
                    + "\n\nalways begin\n   #5  clk <= ~clk; // 200MHz\nend"
                    + "\n\ninitial begin"
                    + "\n   clk <= 0; @(posedge clk);"
                    + "\n   rst <= 1; @(posedge clk);"
                    + "\n   rst <= 0; @(posedge clk);\nend"
                    + "\n\ninitial begin\n  // code... \n    @(negedge rst);\n    $finish;\nend"
                    + "\n\ninitial begin\n  $dumpfile(\"" + item + ".vcd\");"
                    + "\n   $dumpvars(-1, " + item + ");"
                    + "\nend\n\nendmodule")
                tar.close()


def templateMakefileFile():
    makefile = open('script/Makefile', 'w')

    for dirc, file in files.items():
        if (dirc ==  directory[0]):
            for item in file:
            	if (item == files["core"][2]):
            		makefile.write("FILE_" + files["core"][2] + " =")
            		for dirc, file in files.items():
            			if (dirc ==  directory[0]):
            				for item in file:
            					makefile.write(" ../core/" + item + ".v")
            		makefile.write(" ../" + directory[1] + "/" + files["core"][2] + "_tb.v" +  "\n")

            	else:
                	makefile.write("FILE_" + item + " = ../core/" + item + ".v ../" + directory[1] + "/" + item + "_tb.v" + "\n")

    makefile.write("\n")

    for dirc, file in files.items():
        if (dirc ==  directory[0]):
            for item in file:
            	 makefile.write(item + "_compile:\n	iverilog -o " + item + " $(FILE_" + item + ")\n\n")
            	 makefile.write(item + "_vvp" + ":\n	vvp " + item + "\n\n")
            	 makefile.write(item + "_gtk" + ":\n	gtkwave " + item + "_tb.vcd\n\n")


    makefile.close()

def templateTclFile():
    pass

def main():

    if len (sys.argv) == 1:
        print("Ошибка: нет ключей. Выберете из предложенного: ")
        for arg, name in args.items():
            print("--" + arg + " - " + name)
    else:
        if len (sys.argv) > 2:
            print ("Ошибка. Введите только один параметр: ")
            for arg, name in args.items():
                print("--" + arg + " - " + name)
            sys.exit (1)

        if   (sys.argv[1] == "--init"):   createFolderFile()
        elif (sys.argv[1] == "--start"):  runFunctionModel()
        elif (sys.argv[1] == "--update"): updateModel()
        elif (sys.argv[1] == "--clear"):  clearProject()
        else: 
            print ("Не знаю такого =( Воспользуйся из предложенного: ")
            for arg, name in args.items():
                print("--" + arg + " - " + name)

if __name__ == '__main__':
    main()