#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
using namespace llvm;

namespace {
  struct SkeletonPass : public FunctionPass {
    static char ID;
    SkeletonPass() : FunctionPass(ID) {}

    bool isFuncLogger(StringRef name) {
      return name == "funcStartLogger";
    }

    virtual bool runOnFunction(Function &F) {
      outs() << F.getName() << "\n";
      if (isFuncLogger(F.getName())) {
        return false;
      }

      //outs() << F.getName() << ":\n";
      //outs() << F;

      for (auto& U : F.uses()) { 
        break;
        User *user = U.getUser();
        //outs() << "    [DOT] " << (uint64_t)(&F) << " -> " << (uint64_t)user << "\n";
        //outs() << "    User:  " << (uint64_t)user;
        //user->print(llvm::outs(), true);
        //outs() << "\n";
      }

      //outs() << "Instr Uses:\n";

      for (auto& B: F) {
        for (auto& I: B) {
          for (auto& U: I.uses()) {
            User* user = U.getUser();
            //outs() << "  [DOT] " << (uint64_t)(&I) << " -> " << (uint64_t)user << "\n";

            //outs() << "    USER: " << (uint64_t)user;
            //user->print(llvm::outs(), true);
            //outs() << "\n";
            //outs() << "    INSRT: " << I << "\n";
          }
        }
      }

      //outs() << "\n\n";
      //return false;


      // Prepare builder for IR modification
      LLVMContext &ctx = F.getContext();
      IRBuilder<> builder(ctx);
      Type *ret_type = Type::getVoidTy(ctx);

      std::vector<Type*> func_start_param_types = {
        builder.getInt8PtrTy()->getPointerTo()
      };
      FunctionType *func_start_log_func_type = 
        FunctionType::get(ret_type, func_start_param_types, false);
      FunctionCallee func_start_log_func = F.getParent()->getOrInsertFunction("funcStartLogger", func_start_log_func_type);

      BasicBlock &entryBB = F.getEntryBlock();
      builder.SetInsertPoint(&entryBB.front());
      Value *func_name = builder.CreateGlobalStringPtr(F.getName());
      Value *args[] = {func_name};
      builder.CreateCall(func_start_log_func, args);
      return true;
    }
  };
}

char SkeletonPass::ID = 0;
static RegisterPass<SkeletonPass> X("sp", "Skeleton Pass",
                             false /* Only looks at CFG */,
                             false /* Analysis Pass */);