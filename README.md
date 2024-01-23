# turntable

`turntable` is an audio-driven musical sequencer interface in the form of a turntable. When active buttons on each vinyl pass the playhead (needle arm), they play their associated sound.

## Installation

### Method 1:

Download .zip file from [live app](https://ccrma.stanford.edu/~eljbuck/256A/hw3/)

### Method 2:

Install from source:

```{bash}
$ git clone https://github.com/eljbuck/turntable.git
```

## Run Instructions

To run the program, ensure that the [latest version](https://chuck.stanford.edu/release/) of ChucK is installed. If version 1.5.2.1 or greater is installed, ChuGL will be included. Otherwise, download [the ChuGL chugin](https://chuck.stanford.edu/release/alpha/chugl/).

From here, navigate to turntable/src in terminal and run the following program:

```{bash}
$ chuck run.ck
```

## App Instructions

Turn on/off sequencer with <kbd>space</kbd>

Use <kbd>←</kbd> and <kbd>→</kbd> to slide phaser

Hold <kbd>v</kbd> while using <kbd>↑</kbd> and <kbd>↓</kbd> to adjust volume

Hold <kbd>t</kbd> while using <kbd>↑</kbd> and <kbd>↓</kbd> to adjust BPM

Pause (and scratch) the records using <kbd>p</kbd>

