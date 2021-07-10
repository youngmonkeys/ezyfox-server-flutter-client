package com.tvd12.ezyfoxserver.client.exception;

/**
 * Created by tavandung12 on 10/24/18.
 */

public class EzyMethodCallException extends RuntimeException {
    private final String code;
    private final String message;

    public EzyMethodCallException(String code, String message) {
        super(message);
        this.code = code;
        this.message = message;
    }

    public EzyMethodCallException(String code, String message, Throwable ex) {
        super(message, ex);
        this.code = code;
        this.message = message;
    }

    public String getCode() {
        return code;
    }

    @Override
    public String getMessage() {
        return message;
    }
}
