#!/bin/bash
set -eux

gcs='git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules'

workdir=$(pwd)

du -hd1

mkdir -p "$workdir"/ComfyUI_Windows_portable

$gcs https://github.com/comfyanonymous/ComfyUI.git \
    "$workdir"/ComfyUI_Windows_portable/ComfyUI

$gcs https://github.com/madebyollin/taesd.git
cp taesd/*.pth \
    "$workdir"/ComfyUI_Windows_portable/ComfyUI/models/vae_approx/
rm -rf taesd

cd "$workdir"/ComfyUI_Windows_portable/ComfyUI/custom_nodes
$gcs https://github.com/bash-j/mikey_nodes.git
$gcs https://github.com/chrisgoringe/cg-use-everywhere.git
$gcs https://github.com/crystian/ComfyUI-Crystools.git
$gcs https://github.com/cubiq/ComfyUI_essentials.git
$gcs https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
$gcs https://github.com/Fannovel16/comfyui_controlnet_aux.git
$gcs https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git
$gcs https://github.com/FizzleDorf/ComfyUI_FizzNodes.git
$gcs https://github.com/jags111/efficiency-nodes-comfyui.git
$gcs https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git
$gcs https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved.git
$gcs https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
$gcs https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
$gcs https://github.com/ltdrdata/ComfyUI-Inspire-Pack.git
$gcs https://github.com/ltdrdata/ComfyUI-Manager.git
$gcs https://github.com/MrForExample/ComfyUI-3D-Pack.git
$gcs https://github.com/MrForExample/ComfyUI-AnimateAnyone-Evolved.git
$gcs https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git
$gcs https://github.com/pythongosssss/ComfyUI-WD14-Tagger.git
$gcs https://github.com/rgthree/rgthree-comfy.git
$gcs https://github.com/shiimizu/ComfyUI_smZNodes.git
$gcs https://github.com/SLAPaper/ComfyUI-Image-Selector.git
$gcs https://github.com/twri/sdxl_prompt_styler.git
$gcs https://github.com/WASasquatch/was-node-suite-comfyui.git
$gcs https://github.com/ZHO-ZHO-ZHO/ComfyUI-InstantID.git

cd "$workdir"
mv python_embeded ComfyUI_Windows_portable

cd "$workdir"/ComfyUI_Windows_portable
mkdir update
cp -r ComfyUI/.ci/update_windows/* ./update/
cp -r ComfyUI/.ci/windows_base_files/* ./

cd "$workdir"
# LZMA2 is way more faster
"C:\Program Files\7-Zip\7z.exe" a -t7z -m0=lzma2 -mx=5 -mfb=32 -md=16m -ms=on -mf=BCJ2 ComfyUI_Windows_portable_cu121.7z ComfyUI_Windows_portable

ls -lah

# For test run, disable custom nodes
cd "$workdir"/ComfyUI_Windows_portable/ComfyUI/custom_nodes
for D in *; do
    if [ -d "${D}" ]; then
        mv "${D}" "${D}".disabled
    fi
done

cd "$workdir"/ComfyUI_Windows_portable
python_embeded/python.exe -s ComfyUI/main.py --quick-test-for-ci --cpu

cd "$workdir"
du -hd1
