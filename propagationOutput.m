function output = propagationOutput(file, recording, folder, output)


cd(folder)
propagationFileName = dir(strcat((recording(1:11)), '*', '1-200_fullT-random_propagation_freq.mat'));


propagationFile = load(propagationFileName.name);
propagation_freq_Hz = propagationFile.propagation_freq_Hz;
propagation_freq_Hz = propagation_freq_Hz(:);


output(file).CA1toDG_Hz = propagation_freq_Hz(2);
output(file).CA3toDG_Hz = propagation_freq_Hz(3);
output(file).ECtoDG_Hz = propagation_freq_Hz(4);
output(file).DGtoCA1_Hz = propagation_freq_Hz(5);
output(file).CA3toCA1_Hz = propagation_freq_Hz(7);
output(file).ECtoCA1_Hz = propagation_freq_Hz(8);
output(file).DGtoCA3_Hz = propagation_freq_Hz(9);
output(file).CA1toCA3_Hz = propagation_freq_Hz(10);
output(file).ECtoCA3_Hz = propagation_freq_Hz(12);
output(file).DGtoEC_Hz = propagation_freq_Hz(13);
output(file).CA1toEC_Hz = propagation_freq_Hz(14);
output(file).CA3toEC_Hz = propagation_freq_Hz(15);

