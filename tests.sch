v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 120 -670 120 -630 {
lab=Vin}
N 120 -670 160 -670 {
lab=Vin}
N 220 -670 250 -670 {
lab=Vout}
N 250 -670 250 -650 {
lab=Vout}
N 250 -590 250 -570 {
lab=GND}
N 120 -570 250 -570 {
lab=GND}
N 510 -670 540 -670 {
lab=#net1}
N 580 -730 580 -700 {
lab=#net2}
N 580 -640 580 -620 {
lab=GND}
N 430 -670 430 -650 {
lab=#net3}
N 430 -670 450 -670 {
lab=#net3}
N 700 -850 700 -710 {
lab=#net4}
N 580 -850 700 -850 {
lab=#net4}
N 580 -850 580 -790 {
lab=#net4}
C {res.sym} 190 -670 1 0 {name=R1
value=1k
footprint=1206
device=resistor
m=1}
C {capa.sym} 250 -620 0 0 {name=C1
m=1
value=1u
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 250 -570 0 0 {name=l1 lab=GND}
C {vsource.sym} 120 -600 0 0 {name=V1 value="PULSE(0 1 0 0.1m 0.1m 1m 2m)"}
C {lab_pin.sym} 120 -660 0 0 {name=p1 sig_type=std_logic lab=Vin}
C {lab_pin.sym} 250 -660 2 0 {name=p2 sig_type=std_logic lab=Vout}
C {code.sym} 310 -830 0 0 {name=s1 only_toplevel=false 
value="
.tran 1u 10m
.save all
"}
C {npn.sym} 560 -670 0 0 {name=Q1
model=MMBT2222
device=MMBT2222
footprint=SOT23
area=1
m=1}
C {gnd.sym} 580 -620 0 0 {name=l2 lab=GND}
C {res.sym} 480 -670 1 0 {name=R2
value=1k
footprint=1206
device=resistor
m=1}
C {res.sym} 580 -760 2 0 {name=R3
value=100
footprint=1206
device=resistor
m=1}
C {vsource.sym} 430 -620 0 0 {name=V2 value=3 savecurrent=false}
C {vsource.sym} 700 -680 0 0 {name=V3 value=10 savecurrent=false}
C {gnd.sym} 700 -650 0 0 {name=l3 lab=GND}
C {gnd.sym} 430 -590 0 0 {name=l4 lab=GND}
