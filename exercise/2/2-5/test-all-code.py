import os
import subprocess


class Tester(object):
    def __init__(self, dir='./'):
        self.dir = dir
        self.report_fn = "report.txt"
        self.interpreter = "racket"
        self.suffix = ".rkt"

    def _program_files(self):
        programs_list = []
        all_files = os.listdir(self.dir)
        for fn in all_files:
            if os.path.isfile(fn) and \
                os.path.splitext(fn)[-1]==".rkt":
                programs_list.append(fn)
        return programs_list

    def run_programs(self):
        self._empty_report()
        fns = self._program_files()
        print(fns)
        for fn in fns:
            cmd = self.interpreter + " " + fn
            # print(fn,":",end='')
            status, output = subprocess.getstatusoutput(cmd)
            self._report(fn, status, output)
    
    def _report(self, fn, status, output):
        print("+"*70)
        print(fn,":",status)
        print(status)
        print(output)
        # with open(self.report_fn, 'w+') as f: 
        #     f.writelines(fn+":"+str(status))       
        #     f.writelines(output)
        #     f.writelines("+"*50)

    def _empty_report(self):
        pass
        # with open(self.report_fn, 'r+') as f:
        #     f.seek(0)
        #     f.truncate()

if __name__ == "__main__":
    t = Tester()
    t.run_programs()