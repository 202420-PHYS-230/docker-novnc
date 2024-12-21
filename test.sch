v {xschem version=3.1.0 file_version=1.2
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
