#!/usr/bin/env zsh
#SBATCH -J cv_0
#SBATCH -o cv_0_%j.out
#SBATCH -c 4
#SBATCH --mem=1G

# Download and extract data
d=${WORK}/imagenet
mkdir ${d}
files=(ILSVRC2012_img_val.tar\
 ILSVRC2012_img_test_v10102019.tar\
 ILSVRC2012_img_train_t3.tar\
 ILSVRC2012_img_train.tar)
for f in ${files[@]}; do
  curl -s https://image-net.org/data/ILSVRC/2012/${f} -o ${d}/${f} &
done

# Clone the example repo
git clone --depth 1 https://github.com/NVIDIA/DeepLearningExamples &

# Wait for the above commands to complete
wait

