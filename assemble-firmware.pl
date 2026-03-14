#!/usr/bin/perl

use strict;
use warnings;

use File::Basename;
use File::Path;

my $fwsrc2 = "dvb-firmware.git";
my $fwsrc3 = "firmware-misc";

my $fwlist = shift;
die "no firmware list specified" if !$fwlist || ! -f $fwlist;

my $target = shift;
die "no target directory" if !$target || ! -d $target;

my $FORCE_INCLUDE = [
    'iwlwifi-*.pnvm',
];

my $ALLOW_MISSING = {};
# debian squeeze also misses those files, and upstream linux-firmware
# does not currently ship them for the kernel versions we target.
# This list is generated from assemble-firmware runs on updated
# linux-firmware.git and can be pruned further if you vendor in
# additional blobs under firmware-misc/ or dvb-firmware.git/.
foreach my $fw (qw(
3826.arm
3826.eeprom
adf7242_firmware.bin
amdgpu/aldebaran_cap.bin
amdgpu/cyan_skillfish_gpu_info.bin
amdgpu/gc_11_0_0_toc.bin
amdgpu/gc_11_0_3_mes.bin
amdgpu/gc_11_5_4_imu.bin
amdgpu/gc_11_5_4_me.bin
amdgpu/gc_11_5_4_mec.bin
amdgpu/gc_11_5_4_mes1.bin
amdgpu/gc_11_5_4_mes_2.bin
amdgpu/gc_11_5_4_pfp.bin
amdgpu/gc_11_5_4_rlc.bin
amdgpu/gc_12_1_0_imu.bin
amdgpu/gc_12_1_0_mec.bin
amdgpu/gc_12_1_0_mes1.bin
amdgpu/gc_12_1_0_mes.bin
amdgpu/gc_12_1_0_rlc.bin
amdgpu/gc_12_1_0_uni_mes.bin
amdgpu/ip_discovery.bin
amdgpu/navi10_mes.bin
amdgpu/navi12_cap.bin
amdgpu/psp_13_0_15_sos.bin
amdgpu/psp_13_0_15_ta.bin
amdgpu/psp_15_0_0_toc.bin
amdgpu/psp_15_0_8_toc.bin
amdgpu/sdma_6_1_4.bin
amdgpu/sdma_7_1_0.bin
amdgpu/sienna_cichlid_cap.bin
amdgpu/sienna_cichlid_mes1.bin
amdgpu/sienna_cichlid_mes.bin
amdgpu/vega10_cap.bin
amdgpu/vcn_5_3_0.bin
amdnpu/17f0_20/npu.sbin
ast_dp501_fw.bin
ath10k/QCA6174/hw2.1/firmware-4.bin
ath10k/QCA6174/hw3.0/firmware-5.bin
ath10k/QCA9887/hw1.0/board-2.bin
ath10k/QCA988X/hw2.0/board-2.bin
ath10k/QCA988X/hw2.0/firmware-2.bin
ath10k/QCA988X/hw2.0/firmware-3.bin
ath6k/AR6003/hw2.0/bdata.bin
ath6k/AR6003/hw2.1.1/bdata.bin
ath6k/AR6004/hw1.0/bdata.bin
ath6k/AR6004/hw1.0/bdata.DB132.bin
ath6k/AR6004/hw1.0/fw.ram.bin
ath6k/AR6004/hw1.1/bdata.bin
ath6k/AR6004/hw1.1/bdata.DB132.bin
ath6k/AR6004/hw1.1/fw.ram.bin
ath6k/AR6004/hw1.2/fw.ram.bin
ath6k/AR6004/hw1.3/fw.ram.bin
b43legacy/ucode2.fw
b43legacy/ucode4.fw
b43/ucode11.fw
b43/ucode13.fw
b43/ucode14.fw
b43/ucode15.fw
b43/ucode16_lp.fw
b43/ucode16_mimo.fw
b43/ucode24_lcn.fw
b43/ucode25_lcn.fw
b43/ucode25_mimo.fw
b43/ucode26_mimo.fw
b43/ucode29_mimo.fw
b43/ucode30_mimo.fw
b43/ucode33_lcn40.fw
b43/ucode40.fw
b43/ucode42.fw
b43/ucode5.fw
b43/ucode9.fw
bfubase.frm
brcm/brcmbt4377*.bin
brcm/brcmbt4377*.ptb
brcm/brcmbt4378*.bin
brcm/brcmbt4378*.ptb
brcm/brcmbt4387*.bin
brcm/brcmbt4387*.ptb
brcm/brcmbt4388*.bin
brcm/brcmbt4388*.ptb
brcm/brcmfmac43430b0-sdio.bin
brcm/brcmfmac43439-sdio.bin
brcm/brcmfmac43439-sdio.clm_blob
brcm/brcmfmac43456-sdio.bin
brcm/brcmfmac4355c1-pcie.bin
brcm/brcmfmac4355c1-pcie.clm_blob
brcm/brcmfmac4355-pcie.bin
brcm/brcmfmac4355-pcie.clm_blob
brcm/brcmfmac4359c-pcie.bin
brcm/brcmfmac4359-pcie.bin
brcm/brcmfmac4359-sdio.bin
brcm/brcmfmac4364b2-pcie.bin
brcm/brcmfmac4364b2-pcie.clm_blob
brcm/brcmfmac4364b3-pcie.bin
brcm/brcmfmac4364b3-pcie.clm_blob
brcm/brcmfmac4365b-pcie.bin
brcm/brcmfmac4365c-pcie.bin
brcm/brcmfmac43752-pcie.bin
brcm/brcmfmac43752-pcie.clm_blob
brcm/brcmfmac43752-sdio.bin
brcm/brcmfmac43752-sdio.clm_blob
brcm/brcmfmac4377b3-pcie.bin
brcm/brcmfmac4377b3-pcie.clm_blob
brcm/brcmfmac4378b1-pcie.bin
brcm/brcmfmac4378b1-pcie.clm_blob
brcm/brcmfmac4378b3-pcie.bin
brcm/brcmfmac4378b3-pcie.clm_blob
brcm/brcmfmac4387c2-pcie.bin
brcm/brcmfmac4387c2-pcie.clm_blob
brcm/brcmfmac*-pcie.*.clm_blob
brcm/brcmfmac*-pcie.*.txcap_blob
brcm/brcmfmac*-pcie.txt
brcm/brcmfmac*-sdio.*.bin
BT3CPCC.bin
c218tunx.cod
c320tunx.cod
comedi/jr3pci.idm
cp204unx.cod
daqboard2000_firmware.bin
dvb_driver_si2141_rom60.fw
dvb_driver_si2141_rom61.fw
dvb_driver_si2146_rom11.fw
dvb_driver_si2147_rom50.fw
dvb_driver_si2148_rom32.fw
dvb_driver_si2148_rom33.fw
dvb_driver_si2157_rom50.fw
dvb_driver_si2158_rom51.fw
dvb_driver_si2177_rom50.fw
dvb_driver_si2178_rom50.fw
fw.ram.bin
habanalabs/gaudi/gaudi-boot-fit.itb
habanalabs/gaudi/gaudi-fit.itb
habanalabs/gaudi/gaudi_tpc.bin
hcwamc.rbf
idt82p33xxx.bin
inside-secure/eip197b/ifpp.bin
inside-secure/eip197b/ipue.bin
inside-secure/eip197d/ifpp.bin
inside-secure/eip197d/ipue.bin
intel/vpu/vpu_60xx_v1.bin
isight.fw
isl3886pci
isl3886usb
isl3887usb
iwlwifi-6000-6.ucode
iwlwifi-br-a0-pe-a0-96.ucode
iwlwifi-br-a0-petc-a0-96.ucode
iwlwifi-bz-a0-fm4-b0-102.ucode
iwlwifi-bz-a0-fm4-b0-86.ucode
iwlwifi-bz-a0-fm4-b0-92.ucode
iwlwifi-bz-a0-fm4-b0-96.ucode
iwlwifi-bz-a0-fm4-b0-c101.ucode
iwlwifi-bz-a0-fm4-b0-c99.ucode
iwlwifi-bz-a0-fm4-b0.pnvm
iwlwifi-bz-a0-fm-b0-102.ucode
iwlwifi-bz-a0-fm-b0-86.ucode
iwlwifi-bz-a0-fm-b0-92.ucode
iwlwifi-bz-a0-fm-b0-96.ucode
iwlwifi-bz-a0-fm-b0-c101.ucode
iwlwifi-bz-a0-fm-b0-c99.ucode
iwlwifi-bz-a0-fm-b0.pnvm
iwlwifi-bz-a0-fm-c0-102.ucode
iwlwifi-bz-a0-fm-c0-86.ucode
iwlwifi-bz-a0-fm-c0-92.ucode
iwlwifi-bz-a0-fm-c0-96.ucode
iwlwifi-bz-a0-fm-c0-c101.ucode
iwlwifi-bz-a0-fm-c0-c99.ucode
iwlwifi-bz-a0-fm4-b0-cIWL_BZ_UCODE_CORE_MAX.ucode
iwlwifi-bz-a0-fm-b0-cIWL_BZ_UCODE_CORE_MAX.ucode
iwlwifi-bz-a0-fm-c0-cIWL_BZ_UCODE_CORE_MAX.ucode
iwlwifi-bz-a0-fm-c0.pnvm
iwlwifi-bz-a0-gf4-a0-100.ucode
iwlwifi-bz-a0-gf4-a0-86.ucode
iwlwifi-bz-a0-gf4-a0-92.ucode
iwlwifi-bz-a0-gf4-a0-96.ucode
iwlwifi-bz-a0-gf4-a0.pnvm
iwlwifi-bz-a0-gf-a0-100.ucode
iwlwifi-bz-a0-gf-a0-86.ucode
iwlwifi-bz-a0-gf-a0-92.ucode
iwlwifi-bz-a0-gf-a0-96.ucode
iwlwifi-bz-a0-gf-a0.pnvm
iwlwifi-bz-a0-hr-b0-100.ucode
iwlwifi-bz-a0-hr-b0-86.ucode
iwlwifi-bz-a0-hr-b0-92.ucode
iwlwifi-bz-a0-hr-b0-96.ucode
iwlwifi-dr-a0-pe-a0-102.ucode
iwlwifi-dr-a0-pe-a0-96.ucode
iwlwifi-dr-a0-pe-a0-c101.ucode
iwlwifi-dr-a0-pe-a0-c99.ucode
iwlwifi-gl-b0-fm-b0-102.ucode
iwlwifi-gl-b0-fm-b0-86.ucode
iwlwifi-gl-b0-fm-b0-92.ucode
iwlwifi-gl-b0-fm-b0-96.ucode
iwlwifi-gl-b0-fm-b0-c101.ucode
iwlwifi-gl-b0-fm-b0-c99.ucode
iwlwifi-gl-b0-fm-b0-cIWL_BZ_UCODE_CORE_MAX.ucode
iwlwifi-gl-b0-fm-b0.pnvm
iwlwifi-gl-c0-fm-c0-102.ucode
iwlwifi-gl-c0-fm-c0-cIWL_BZ_UCODE_CORE_MAX.ucode
iwlwifi-gl-c0-fm-c0-c99.ucode
iwlwifi-ma-a0-gf4-a0-100.ucode
iwlwifi-ma-a0-gf4-a0-86.ucode
iwlwifi-ma-a0-gf4-a0-89.ucode
iwlwifi-ma-a0-gf4-a0.pnvm
iwlwifi-ma-a0-gf-a0-100.ucode
iwlwifi-ma-a0-gf-a0-86.ucode
iwlwifi-ma-a0-gf-a0-89.ucode
iwlwifi-ma-a0-gf-a0.pnvm
iwlwifi-ma-a0-hr-b0-100.ucode
iwlwifi-ma-a0-hr-b0-86.ucode
iwlwifi-ma-a0-hr-b0-89.ucode
iwlwifi-ma-a0-mr-a0-86.ucode
iwlwifi-ma-a0-mr-a0-89.ucode
iwlwifi-ma-b0-gf4-a0-100.ucode
iwlwifi-ma-b0-gf-a0-100.ucode
iwlwifi-ma-b0-hr-b0-100.ucode
iwlwifi-ma-b0-mr-a0-86.ucode
iwlwifi-ma-b0-mr-a0-89.ucode
iwlwifi-Qu-b0-hr-b0-100.ucode
iwlwifi-Qu-c0-hr-b0-100.ucode
iwlwifi-QuZ-a0-hr-b0-100.ucode
iwlwifi-sc2-a0-fm-c0-102.ucode
iwlwifi-sc2-a0-fm-c0-86.ucode
iwlwifi-sc2-a0-fm-c0-92.ucode
iwlwifi-sc2-a0-fm-c0-96.ucode
iwlwifi-sc2-a0-fm-c0-c101.ucode
iwlwifi-sc2-a0-fm-c0-c99.ucode
iwlwifi-sc2-a0-fm-c0.pnvm
iwlwifi-sc2-a0-wh-a0-102.ucode
iwlwifi-sc2-a0-wh-a0-86.ucode
iwlwifi-sc2-a0-wh-a0-92.ucode
iwlwifi-sc2-a0-wh-a0-96.ucode
iwlwifi-sc2-a0-wh-a0-c101.ucode
iwlwifi-sc2-a0-wh-a0-c99.ucode
iwlwifi-sc2-a0-wh-a0.pnvm
iwlwifi-sc2f-a0-fm-c0-86.ucode
iwlwifi-sc2f-a0-fm-c0-92.ucode
iwlwifi-sc2f-a0-fm-c0-96.ucode
iwlwifi-sc2f-a0-fm-c0.pnvm
iwlwifi-sc2f-a0-wh-a0-86.ucode
iwlwifi-sc2f-a0-wh-a0-92.ucode
iwlwifi-sc2f-a0-wh-a0-96.ucode
iwlwifi-sc2f-a0-wh-a0.pnvm
iwlwifi-sc-a0-fm-b0-102.ucode
iwlwifi-sc-a0-fm-b0-86.ucode
iwlwifi-sc-a0-fm-b0-92.ucode
iwlwifi-sc-a0-fm-b0-96.ucode
iwlwifi-sc-a0-fm-b0-c101.ucode
iwlwifi-sc-a0-fm-b0-c99.ucode
iwlwifi-sc-a0-fm-b0.pnvm
iwlwifi-sc-a0-fm-c0-102.ucode
iwlwifi-sc-a0-fm-c0-86.ucode
iwlwifi-sc-a0-fm-c0-92.ucode
iwlwifi-sc-a0-fm-c0-96.ucode
iwlwifi-sc-a0-fm-c0-c99.ucode
iwlwifi-sc-a0-fm-c0.pnvm
iwlwifi-sc-a0-gf4-a0-100.ucode
iwlwifi-sc-a0-gf4-a0-86.ucode
iwlwifi-sc-a0-gf4-a0-92.ucode
iwlwifi-sc-a0-gf4-a0-96.ucode
iwlwifi-sc-a0-gf4-a0.pnvm
iwlwifi-sc-a0-gf-a0-86.ucode
iwlwifi-sc-a0-gf-a0-92.ucode
iwlwifi-sc-a0-gf-a0-96.ucode
iwlwifi-sc-a0-gf-a0.pnvm
iwlwifi-sc-a0-hr-b0-100.ucode
iwlwifi-sc-a0-hr-b0-86.ucode
iwlwifi-sc-a0-hr-b0-92.ucode
iwlwifi-sc-a0-hr-b0-96.ucode
iwlwifi-sc-a0-wh-a0-102.ucode
iwlwifi-sc-a0-wh-a0-86.ucode
iwlwifi-sc-a0-wh-a0-92.ucode
iwlwifi-sc-a0-wh-a0-96.ucode
iwlwifi-sc-a0-wh-a0-c101.ucode
iwlwifi-sc-a0-wh-a0-c99.ucode
iwlwifi-sc-a0-wh-a0.pnvm
iwlwifi-so-a0-gf-a0-100.ucode
iwlwifi-so-a0-hr-b0-100.ucode
iwlwifi-so-a0-jf-b0-86.ucode
iwlwifi-so-a0-jf-b0-89.ucode
iwlwifi-ty-a0-gf-a0-100.ucode
ks7010sd.rom
lantiq/xrx200_phy11g_a14.bin
lantiq/xrx200_phy11g_a22.bin
lantiq/xrx200_phy22f_a14.bin
lantiq/xrx200_phy22f_a22.bin
lantiq/xrx300_phy11g_a21.bin
lantiq/xrx300_phy22f_a21.bin
lattice-ecp3.bit
libertas/gspi8385.bin
libertas/gspi8385_helper.bin
libertas/gspi8385_hlp.bin
libertas/usb8388.bin
me2600_firmware.bin
me4000_firmware.bin
metronome.wbf
mrvl/pcie8766_uapsta.bin
mrvl/pcie8897_uapsta_a0.bin
mrvl/sd8786_uapsta.bin
mrvl/sd8987_uapsta.bin
mrvl/sdiouart8997_combo_v4.bin
mrvl/sdiouartiw416_combo_v0.bin
mt7603_e1.bin
mt7603_e2.bin
mt7628_e1.bin
mt7628_e2.bin
mwl8k/fmimage_8363.fw
mwl8k/helper_8363.fw
ni6534a.bin
niscrb01.bin
niscrb02.bin
pca200e_ecd.bin2
plfxlc/lifi-x.bin
prism2_ru.fw
qat_6xxx.bin
qat_6xxx_mmp.bin
ram.bin
regulatory.db
regulatory.db.p7s
renesas_usb_fw.mem
RTL8192E/boot.img
RTL8192E/data.img
RTL8192E/main.img
rtl_bt/rtl8723cs_cg_config.bin
rtl_bt/rtl8723cs_cg_fw.bin
rtl_bt/rtl8723cs_vf_config.bin
rtl_bt/rtl8723cs_vf_fw.bin
rtl_bt/rtl8723ds_config.bin
rtl_bt/rtl8723ds_fw.bin
rtl_bt/rtl8761a_config.bin
rtl_bt/rtl8852bs_config.bin
rtl_bt/rtl8852bs_fw.bin
rtlwifi/rtl8723bu_bt.bin
rtlwifi/rtl8723efw.bin
sd8686.bin
sd8686_helper.bin
softing-4.6/bcard2.bin
softing-4.6/bcard.bin
softing-4.6/cancard.bin
softing-4.6/cancrd2.bin
softing-4.6/cansja.bin
softing-4.6/ldcard2.bin
softing-4.6/ldcard.bin
solos-db-FPGA.bin
solos-Firmware.bin
solos-FPGA.bin
tehuti/aqr105-tn40xx.cld
usb8388.bin
wd719x-risc.bin
wd719x-wcs.bin
wil6210_sparrow_plus.fw
wil6436.brd
wil6436.fw
wlan/prima/WCNSS_qcom_wlan_nv.bin
xe/nvl_guc_70.55.4.bin
)) {
    $ALLOW_MISSING->{$fw} = 1;
}

sub copy_fw {
    my ($src, $dstfw) = @_;

    my $dest = "$target/$dstfw";
    return if -f $dest || -f "${dest}.xz";

    mkpath dirname($dest);
    system ("cp '$src' '$dest'") == 0 or die "copy '$src' to '$dest' failed!\n";
}

my ($fwdone, $fwbase_name, $error) = ({}, {}, 0);

sub add_fw :prototype($$) {
    my ($fw, $mod) = @_;

    return if $fw =~ m/\b(?:microcode_amd|amd_sev_)/; # contained in amd64-microcode

    my $fw_name = basename($fw);
    $fwbase_name->{$fw_name} = 1;

    return if $mod =~ m|^kernel/sound|;
    return if $mod =~ m|^kernel/drivers/isdn|;

    # skip ZyDas usb wireless, use package zd1211-firmware instead
    return if $fw =~ m|^zd1211/|;

    # skip atmel at76c50x wireless networking chips, use package atmel-firmware instead
    return if $fw =~ m|^atmel_at76c50|;

    # skip Bluetooth dongles based on the Broadcom BCM203x, use package bluez-firmware instead
    return if $fw =~ m|^BCM2033|;

    return if $fw =~ m|^xc3028-v27\.fw|; # found twice!
    return if $fw =~ m|^ueagle-atm/|; # where are those files?

    return if $fwdone->{$fw};
    $fwdone->{$fw} = 1;

    my $fwdest = $fw;
    if ($fw eq 'libertas/gspi8686.bin') {
	$fw = 'libertas/gspi8686_v9.bin';
    }
    if ($fw eq 'libertas/gspi8686_hlp.bin') {
	$fw = 'libertas/gspi8686_v9_helper.bin';
    }

    if ($fw eq 'PE520.cis') {
	$fw = 'cis/PE520.cis';
    }

    if (-e "$target/$fw") {
	warn "WARN: allowed to skip existing '$fw'\n" if $ALLOW_MISSING->{$fw};
	return;
    }
    if (-f "$fwsrc3/$fw") {
	copy_fw("$fwsrc3/$fw", $fwdest);
	return;
    }

    my $module = basename($mod);
    my $name = basename($fw);
    my $fw_dir = dirname($fw);

    if ($name =~ /\*/) {
	die "cannot handle GLOBs in path stem ('$fw_dir'), switch find below to regex and transform GLOB to regex"
	    if $fw_dir =~ /\*/;

	my $sr = `find '$target/$fw_dir' \\( -type f -o -type l \\) -name '$name'`;
	chomp $sr;
	if ($sr) {
	    for my $f (split("\n", $sr)) {
		print "found $f for GLOB '$fw'\n";
		my $f_name = basename($f);
		$fwbase_name->{$f_name} = 1;
	    }
	    warn "WARN: allowed to skip existing '$fw'\n" if $ALLOW_MISSING->{$fw};
	    return;
	} else {
	    return if $ALLOW_MISSING->{$fw};
	    warn "ERROR: unable to find FW for GLOB ($module): $fw\n";
	    $error++;
	}
    }

    if ($fw =~ m|/|) {
	return if $ALLOW_MISSING->{$fw};

	warn "ERROR: unable to find firmware ($module): $fw\n";
	$error++;
	return;
    }

    my $sr = `find '$target' \\( -type f -o -type l \\) -name '$name'`;
    chomp $sr;
    if ($sr) {
	my $found = 0;
	for my $f (split("\n", $sr)) {
	    if ($f =~ /$fw$/) {
		print "found linked $fw in $f\n";
		$found = 1;
	    }
	}
	return if $found;
    }

    $sr = `find '$fwsrc2' -type f -name '$name'`;
    chomp $sr;
    if ($sr) {
	print "found $fw in $sr\n";
	copy_fw($sr, $fwdest);
	return;
    }

    $sr = `find '$fwsrc3' -type f -name '$name'`;
    chomp $sr;
    if ($sr) {
	print "found $fw in $sr\n";
	copy_fw($sr, $fwdest);
	return;
    }

    return if $ALLOW_MISSING->{$fw};
    return if $fw =~ m|^dvb-| || $fw =~ m|\.inp$|;

    warn "ERROR: unable to find firmware ($module): $fw\n";
    $error++;
    return;
}

open(my $fd, '<', $fwlist);
while(defined(my $line = <$fd>)) {
    chomp $line;
    my ($fw, $mod) = split(/\s+/, $line, 2);

    add_fw($fw, $mod);
}
close($fd);

for my $fw ($FORCE_INCLUDE->@*) {
    add_fw($fw, 'FORCE_INCLUDE');
}

exit($error) if $error;

my $target_fw_string = `find '$target' -type f -o -type l`;
chomp $target_fw_string;
exit(-1) if !$target_fw_string;

my $all_fw_files = [ split("\n", $target_fw_string) ];

my ($keep, $delete) = (0, 0);

my $link_target = {};
for my $f (@$all_fw_files) {
    next if ! -l $f;
    my $link = basename($f);
    my $file = readlink($f);
    my $target = basename($file);
    $link_target->{$target} = 1 if $fwbase_name->{$link};
    $link_target->{$file} = 1 if $fwbase_name->{$link};
}

for my $f (@$all_fw_files) {
    my $name = basename($f);

    if ($fwbase_name->{$name}) {
	$keep++;
    } elsif ($link_target->{$name}) {
	#print "skip link target '$f'\n";
	$keep++;
    } else {
	print "delete unreferenced $f\n";
	unlink $f or warn "ERROR deleting '$f' - $!\n";
	$delete++;
    }
}

print "cleanup end result: keep: $keep, delete: $delete\n";

# just some random boundary to catch some stupid '*' GLOB errors, adapt as needed.
die "delete number is awfully low ($delete < 100)\n" if $delete < 100;

exit(0);
