// from facebook comment asking help

(
	Tdef(\kiko, {
		var num_it_fi,num_it_rv,
		num_it_fk,num_it_fk2,num_it_fk3,num_it_fk4;

		var dur_envio_fi, dur_envio_rv,
		dur_envio_fk, dur_envio_fk2, dur_envio_fk3,dur_envio_fk4;

		var ar = (..99), dur = Array.fill(ar.size,0.2);
		~iteradores = {
			~it_env_freq_impulse = {
				arg no_iteraciones, lista_dur,valor_recibido;
				var cont_i=0;

				("Modificando Frecuencia del objeto Impulse").postln;
				no_iteraciones.do{

					var aux_envio;
					aux_envio=valor_recibido.at(cont_i);
					~busfi.set(aux_envio);
					lista_dur.at(cont_i).wait;
					cont_i=cont_i+1;

				}; 
				cont_i=0;
			};
			//fin frecuencia del impulso

			// reverb
			~it_env_reverb = {
				arg no_iteraciones, lista_dur,valor_recibido;
				var cont=0;
				no_iteraciones.do{

					var aux_envio;
					aux_envio=valor_recibido.at(cont);
					~bus_rv.set(aux_envio);
					lista_dur.at(cont).wait;
					cont=cont+1;

				}; 
				cont=0;
			};
			// fin reverb

			// frecuencia lftri
			~it_env_freq_lftri = {
				arg no_iteraciones, lista_dur,valor_recibido;
				var cont=0;

				("Modificando Frecuencia del objeto LFTri").postln;
				no_iteraciones.do{

					var aux_envio;
					aux_envio=valor_recibido.at(cont);
					~bus_flftri.set(aux_envio);
					lista_dur.at(cont).wait;
					cont=cont+1;

				}; 
				cont=0;
			};
			//fin frecuencia lftri

			//frecuencia del resonador 1
			~it_env_freq_klank = {
				arg no_iteraciones, lista_dur,valor_recibido;
				var cont=(-1); ("Modificando Frecuencia del objeto Impulse").postln;

				no_iteraciones.do{

					var aux_envio;
					aux_envio=valor_recibido.at(cont);
					~bus_fk.set(aux_envio);
					lista_dur.at(cont).wait;
					cont=cont+1;

				}; 
				cont=0;
			};
			// fin frecuencia del resonador 1

			//frecuencia del resonador 2
			~it_env_freq_klank2 = {
				arg no_iteraciones, lista_dur,valor_recibido;
				var cont=(-1);
				no_iteraciones.do{

					var aux_envio;
					aux_envio=valor_recibido.at(cont);
					~bus_fk2.set(aux_envio);
					lista_dur.at(cont).wait;
					cont=cont+1;

				}; 
				cont=0;
			};
			// fin frecuencia del resonador 2

			//frecuencia del resonador 3
			~it_env_freq_klank3 = {
				arg no_iteraciones, lista_dur,valor_recibido;
				var cont=(-1);
				no_iteraciones.do{

					var aux_envio;
					aux_envio=valor_recibido.at(cont);
					~bus_fk3.set(aux_envio);
					lista_dur.at(cont).wait;
					cont=cont+1;

				}; 
				cont=0;
			};
			// fin frecuencia del resonador 3

			//frecuencia del resonador 4
			~it_env_freq_klank4 = {
				arg no_iteraciones, lista_dur,valor_recibido;
				var cont=(-1);
				no_iteraciones.do{

					var aux_envio;
					aux_envio=valor_recibido.at(cont);
					~bus_fk4.set(aux_envio);
					lista_dur.at(cont).wait;
					cont=cont+1;

				}; 
				cont=0;
			};
			// fin frecuencia del resonador 4

		};
		~iteradores.value;

	})

)

		~iteradores.value;


 (

Tdef(\kio, {
var ar = (..10), dur = Array.fill(ar.size,0.5);
~it_env_freq_impulse.valueArray([ar,dur,ar]);

3.wait;
~it_env_freq_lftri.valueArray([ar,dur,ar]);

}).play

)

(
k=SynthDef(\klanki, {|gate=1,

fk=1330, fk2=300, fk3=700, fk4=500, modulador_fk=1.4, // control de resonadores
dk = 1, dk2 =1 , dk3 = 1, dk4=1, modulador_dk=1, //
freq_impulso= 24, //
freq_lftri=222, // Control de osciladores
freq_blip = 0, //

riverb = 2, harm =3, // Control de efectos

duracion_general=300,
amplitud_general=0.09

|
var klank, filtro_ataque,objt_g,objt_h,select,envgen,env_1,reverb,combl;

env_1=Env.perc(0.3,duracion_general);
envgen=EnvGen.kr(env_1,gate,doneAction:2);

klank= DynKlank.ar(`[[fk,fk2,fk3,fk4]*modulador_fk,nil, [dk,dk2,dk3,dk4]*modulador_dk], Impulse.ar(freq_impulso, 0, amplitud_general

))*LFTri.ar(freq_lftri)*Blip.ar(freq_blip,harm);

combl=CombN.ar(klank,0.03,0.09,riverb);
filtro_ataque=LPF.ar(combl,1000)*envgen;

Out.ar([0,1],filtro_ataque);

}).send(s).add

)

~busfi =Bus.control(s);
~busrv=Bus.control(s);
~bus_flftri=Bus.control(s);

~bus_fk=Bus.control(s);
~bus_fk2=Bus.control(s);
~bus_fk3=Bus.control(s);
~bus_fk4=Bus.control(s);

k=Synth(\klanki);

(

k.map(\freq_impulso, ~busfi);
k.map(\freq_lftri, ~bus_flftri);
Tdef(\kiko).play;

)



/////////////////////////

(
Tdef(\task1, {
	14.do { arg idx;
		"task1: set a bus: %".format(idx).postln;
		1.wait;
	}
});

Tdef(\task2, {
	14.do { arg idx;
		"task2: set a bus: %".format(idx).postln;
		0.7.wait;
	}
});

Tdef(\task1).play;
Tdef(\task2).play;
)
