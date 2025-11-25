#include "tainter.h"

int main(int argc, char** argv){
	string ir_file = string(argv[1]);	//input the ir path
	string var_file = string(argv[2]);	//input the variable mapping path
	std::vector<struct ConfigVariableNameInfo *> config_names;
	if (!readConfigVariableNames(var_file, config_names)) exit(1);
	
	LLVMContext context; 
	SMDiagnostic Err;
	std::unique_ptr<llvm::Module> module;
	buildModule(module, context, Err, ir_file);	//build the llvm module based on ir
	std::vector<struct GlobalVariableInfo *> gvlist = getGlobalVariableInfo(module, config_names);	//conduct Configuration Variable Mapping
	startAnalysis(gvlist, true, true);		//Taint Analysis with indirect data-flow, and indirect control-flow

	string output_file = var_file.substr(0, var_file.find_last_of(".")) + "-records.dat";
	
	llvm::outs() << "\n========== Analysis Results ==========\n";
	
	for (auto i = gvlist.begin(), e = gvlist.end(); i != e; i++)
	{
		struct GlobalVariableInfo *gv_info = *i;
		llvm::outs() << "Variable: " << gv_info->NameInfo->getNameAsString() << "\n";
		
		vector<struct InstInfo *> ExplicitDataFlow = gv_info->getExplicitDataFlow();
		llvm::outs() << "  Explicit DataFlow size: " << ExplicitDataFlow.size() << "\n";
		
		vector<struct InstInfo *> ImplicitDataFlow = gv_info->getImplicitDataFlow();
		llvm::outs() << "  Implicit DataFlow size: " << ImplicitDataFlow.size() << "\n";
		
		// 写入详细结果到文件
		llvm::outs() << "  Writing detailed results to file...\n";
		if (!gv_info->writeToFile(output_file)) {
			llvm::errs() << "  ERROR: Failed to write results to file\n";
			return 1;
		}
		llvm::outs() << "  ✓ Results written successfully\n";
	}
	
	llvm::outs() << "\n========================================\n";
	llvm::outs() << "Analysis completed successfully!\n";
	llvm::outs() << "Detailed results saved to: " << output_file << "\n";
	
	return 0;
}

