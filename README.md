# GW - GPU 算子开发工作区

> CUDA / Blackwell / 东方算芯 / Triton 算子开发学习与代码仓库

---

## 目录结构

```
GW/
├── 00-bw-cutlass-ops/         # Blackwell + CUTLASS 算子开发
│   ├── 00-arch-notes/         #   Blackwell SM 架构笔记（TMA/TMEM/tcgen05.mma）
│   ├── 01-cutlass-examples/   #   CUTLASS 示例代码与学习记录
│   ├── 02-kernel-codes/       #   手写 CUDA Kernel 实现
│   └── 03-perf-notes/         #   性能优化笔记与 Roofline 分析
│
├── 01-df1000-opslib/          # 东方算芯 DF1000 算子库
│   ├── 00-arch-notes/         #   DF1000 架构笔记（软件定义+3D堆叠近存计算）
│   ├── 01-ops-design/         #   算子库设计与接口定义
│   ├── 02-kernel-codes/       #   算子 Kernel 实现
│   └── 03-perf-notes/         #   性能调优记录
│
├── 02-triton-kernels/         # Triton 算子开发
│   ├── 00-learn-notes/         #   Triton 语法与编程模型学习
│   ├── 01-example-codes/       #   Triton Kernel 示例代码
│   ├── 02-bw-optimize/       #   Blackwell Triton (tcgen05) 专项优化
│   └── 03-perf-notes/        #   Triton 性能优化笔记
│
├── auto-commit.ps1            # 每日凌晨 3:00 自动提交脚本
└── auto-commit.log            # 自动提交日志
```

---

## 命名规则

- **顶级目录**：`序号-词根-缩写`，如 `00-bw-cutlass-ops`（bw=Blackwell, cutlass=CUTLASS, ops=operators）
- **子目录**：`序号-词根`，如 `00-arch-notes`（架构笔记）、`02-kernel-codes`（Kernel 代码）
- 所有名称 ≤ 20 字符，望文知意

---

## 各目录说明

### 00-bw-cutlass-ops — Blackwell CUTLASS

NVIDIA Blackwell 架构下的 CUTLASS 算子开发。重点关注：

- **SM100 架构**：第五代 Tensor Core、TMA (Tensor Memory Accelerator)、TMEM (Tensor Memory)、tcgen05.mma
- **CUTLASS 4.x**：SM100 GEMM、CuTe DSL、2-CTA MMA 协作
- **精度支持**：FP4 (NVFP4/FP6/FP8)、TF32、FP16/BF16、INT8、MX 块缩放

### 01-df1000-opslib — 东方算芯 DF1000 算子库

东方算芯 DF1000 芯片的算子库开发。重点关注：

- **DF1000 架构**：软件定义可重构张量计算引擎、3D 混合键合近存计算、520 TFLOPS @ BF16
- **多精度支持**：FP32/FP16/BF16/FP8/FP4 动态重构
- **算子库**：GEMM、Attention、LayerNorm 等核心算子实现

### 02-triton-kernels — Triton 算子开发

Triton 语言算子开发，跨平台 (NVIDIA / 国产芯片)。重点关注：

- **Triton 编程模型**：Block 级并行、tl.dot、Pipeline
- **Blackwell 专项**：tcgen05.mma 支持、TMEM 使用、2-CTA 模式
- **常见算子**：FlashAttention、GEMM、Softmax、LayerNorm 等

---

## 自动提交

仓库已配置 Windows 任务计划 `GitAutoCommit-Daily`，每日凌晨 3:00 自动执行：

1. `git add -A` 暂存所有变更
2. `git commit -m "auto-commit: <时间戳>"` 自动提交
3. `git push origin main` 推送到 GitHub

日志文件：`auto-commit.log`

---

## 相关仓库

- [NVIDIA/cutlass](https://github.com/NVIDIA/cutlass)
- [MooreThreads/mutlass](https://github.com/MooreThreads/mutlass)
- [triton-lang/triton](https://github.com/triton-lang/triton)
- [deepseek-ai/DeepGEMM](https://github.com/deepseek-ai/DeepGEMM)
- [flashinfer-ai/flashinfer](https://github.com/flashinfer-ai/flashinfer)
