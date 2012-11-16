//
//  ToneGenerator2.m
//  Paula
//
//  Created by Grant Damron on 10/30/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "ToneGenerator2.h"

#define BUFFER_COUNT    3
#define BUFFER_DURATION 0.02

static void CheckError(OSStatus error, const char *operation) {
    if(error==noErr) return;
    
    char errorString[20];
    *(UInt32 *)(errorString + 1) = CFSwapInt32HostToBig(error);
    // check if it's a 4-char-code
    if (isprint(errorString[1]) && isprint(errorString[2]) && isprint(errorString[3]) && isprint(errorString[4])) {
        errorString[0] = errorString[5] = '\'';
        errorString[6] = '\0';
    } else
        sprintf(errorString, "%d", (int)error);
    
    fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
    exit(1);
}

@interface ToneGenerator2() {
    NSMutableArray *freqs;
}

@end

@implementation ToneGenerator2

@synthesize audioQueue;
@synthesize bufferSize;
@synthesize globalGain;
@synthesize isOn;
@synthesize startingFrameCount;
@synthesize streamFormat = _streamFormat;
@synthesize waveForm;

- (void)noteOn:(double)freq withGain:(double)g andSoundType:(int)s{
    
    Tone *tone = [[Tone alloc] init];
    tone.gain = g;
    tone.frequency = freq;
    [freqs addObject:tone];
    waveForm = s;
    isOn = YES;
    NSLog(@"Note on: %f", freq);
}

- (void)noteOff:(double) freq {
    for (int i = 0; i < freqs.count; i++) {
        Tone *t = [freqs objectAtIndex:i];
        if (t.frequency==freq) {
            [freqs removeObjectAtIndex:i];
            break;
        }
    }
    if (freqs.count>0) {
        isOn = YES;
    } else {
        isOn = NO;
    }
    
    NSLog(@"Note off");
}

- (void)noteOff {
    //[freqs removeAllObjects];
    isOn = NO;
    NSLog(@"All Notes off");
}

- (void)noteOn {
    isOn = YES;
}

- (id) init {
    if (self = [super init]) {
        freqs = [[NSMutableArray alloc] init];
        isOn = NO;
        CheckError(AudioSessionInitialize(nil, kCFRunLoopDefaultMode, MyInterruptionListener, (__bridge void *) self), "Couldn't initialize the audio session");
        UInt32 category = kAudioSessionCategory_MediaPlayback;
        CheckError(AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category), "Couldn't set category on audio session");
        
        _streamFormat.mSampleRate = 44100.0;
        _streamFormat.mFormatID = kAudioFormatLinearPCM;
        _streamFormat.mFormatFlags = kAudioFormatFlagsCanonical;
        _streamFormat.mChannelsPerFrame = 1;
        _streamFormat.mFramesPerPacket = 1;
        _streamFormat.mBitsPerChannel = 16;
        _streamFormat.mBytesPerFrame = 2;
        _streamFormat.mBytesPerPacket = 2;
        
        CheckError( AudioQueueNewOutput(&_streamFormat, MyAQOutputCallback, (__bridge void *) self, NULL, kCFRunLoopCommonModes, 0, &audioQueue), "Couldn't create the output AudioQueue");
        
        //CheckError(AudioQueueStart(audioQueue, NULL), "Couldn't start the AudioQueue");
        //isOn = YES;
    }
    
    return self;
}

- (OSStatus)fillBuffer:(AudioQueueBufferRef)buffer {
    int frame = 0;
    double frameCount = bufferSize / self.streamFormat.mBytesPerFrame;
    if (isOn) {
        
        memset(buffer->mAudioData, 0, buffer->mAudioDataBytesCapacity);
        double divideBy = (double)freqs.count + 0.1;
        
        for (int i = 0; i < freqs.count; i++) {
            
            Tone *tone = [freqs objectAtIndex:i];
            tone.cycleLength = self.streamFormat.mSampleRate / tone.frequency;
            tone.j = self.startingFrameCount;
            
            for (frame = 0; frame < frameCount; ++frame) {
                SInt16 *data = (SInt16 *)buffer->mAudioData;
                double samp = sin(2 * M_PI * (tone.j / tone.cycleLength));
                if (samp>0.0) samp = 1.0;
                else samp = -1.0;
                
                (data)[frame] += (SInt16) ((samp/divideBy) * 0x8000);
                
                tone.j += 1.0;
                
                if (tone.j > tone.cycleLength)
                    tone.j -= tone.cycleLength;
                
            }
            self.startingFrameCount = [[freqs lastObject] j];
        }
        
    } else {
        memset(buffer->mAudioData, 0, buffer->mAudioDataBytesCapacity);
    }
    buffer->mAudioDataByteSize = bufferSize;
    return noErr;
}


static void MyAQOutputCallback(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inCompleteAQBuffer) {
    ToneGenerator2 *tg = (__bridge ToneGenerator2 *) inUserData;
    CheckError([tg fillBuffer:inCompleteAQBuffer], "Can't refill buffer");
    CheckError(AudioQueueEnqueueBuffer(inAQ, inCompleteAQBuffer, 0, NULL), "Couldn't enqueue the buffer (refill)");
}

void MyInterruptionListener (void *inUserData, UInt32 inInterruptionState) {
    printf("Interrupted! inInterruptionState=%ld\n", inInterruptionState);
    ToneGenerator2 *tg = (__bridge ToneGenerator2 *) inUserData;
    
    switch (inInterruptionState) {
        case kAudioSessionBeginInterruption:
            break;
        case kAudioSessionEndInterruption:
            CheckError(AudioQueueStart(tg.audioQueue, 0), "Couldn't restart the AudioQueue");
            break;
            
        default:
            break;
    }
}

- (void) sineCallback:(AudioQueueBufferRef)buffer {
    
}

- (void) squareCallback:(AudioQueueBufferRef)buffer {
    double j = self.startingFrameCount;
    double cycleLength = self.streamFormat.mSampleRate/[freqs[0] doubleValue];
    int frame = 0;
    double frameCount = bufferSize / self.streamFormat.mBytesPerFrame;
    
    for (frame = 0; frame < frameCount; ++frame) {
        SInt16 *data = (SInt16 *)buffer->mAudioData;
        double samp = sin(2 * M_PI * (j / cycleLength));
        if (samp>0.0) samp = 1.0;
        else samp = -1.0;;
        
        (data)[frame] = (SInt16) ((samp) * 0x8000);
        
        j += 1.0;
        
        if (j > cycleLength)
            j -= cycleLength;
        
    }
    
    self.startingFrameCount = j;
    buffer->mAudioDataByteSize = bufferSize;
}

- (void) noiseCallback:(AudioQueueBufferRef)buffer {
    
}

- (void)start {
    NSLog(@"Starting audio engine");
    // create and enqueue buffers
    AudioQueueBufferRef buffers[BUFFER_COUNT];
    bufferSize = BUFFER_DURATION * self.streamFormat.mSampleRate * self.streamFormat.mBytesPerFrame;
    NSLog(@"bufferSize is %ld", bufferSize);
    
    for (int i = 0; i < BUFFER_COUNT; i++) {
        CheckError(AudioQueueAllocateBuffer(audioQueue, bufferSize, &buffers[i]), "Couldn't allocate AudioQueue buffer");
        CheckError([self fillBuffer:buffers[i]], "Couldn't fill buffer (priming)");
        CheckError(AudioQueueEnqueueBuffer(audioQueue, buffers[i], 0, NULL), "Couldn't enqueue buffer (priming)");
    }
    CheckError(AudioQueueStart(audioQueue, NULL), "Couldn't start the AudioQueue");
}

- (void)stop {
    CheckError(AudioQueueDispose(audioQueue, NO), "Couldn't stop the AudioQueue");
    //CheckError(AudioQueueReset(audioQueue), "Couldn't flush the AudioQueue buffers");
    
    
}

- (void)pause {
    CheckError(AudioQueueStop(audioQueue, NO), "Couldn't stop the AudioQueue");
}

- (void)resume {
    CheckError(AudioQueueStart(audioQueue, NULL), "Couldn't restart the AudioQueue");
}

@end

@implementation Tone

@synthesize frequency;
@synthesize phase;
@synthesize j;
@synthesize cycleLength;
@synthesize sample;
@synthesize gain;

@end
